//
//  SocketService.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/6/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
import SocketIO
import GoogleMaps
import SwiftyJSON

class SocketConnection: NSObject {
    
    static var instance = SocketConnection()
    
    var socket: SocketIOClient!
    
    var isConnected: Bool = false
    var drivers = [Driver]()
    var citys = [City]()
    
    override init() {
        super.init()
        print("Socket Token: \(Authentication.auth.token)")
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func configSocket(baseURL: String, token: String) {
        socket = SocketIOClient.init(socketURL: URL.init(string: baseURL)!)
        socket.config = [.forcePolling(true),.reconnects(true),.connectParams(["token": token])]
    }
    
    func void() {
        //
    }
    
    func checkSocketConnection(completion: @escaping COMPLETION_HANDLER) {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket is connected: \(data)")
            self.isConnected = true
            completion(.success)
        }
        
    }
    
    func sendonCameraIdleLocation(northEastLat: String, northLeastLong: String, southWestLat: String, southWestLong: String, gender: Gender, completion: @escaping COMPLETION_HANDLER) {
        let type = (gender == .male) ? 0:1
        socket.emitWithAck("getDriversLocation", northEastLat,northLeastLong,southWestLat,southWestLong,type).timingOut(after: 1) { (data) in
            guard let result = data[0] as? Int else { completion(.failed) ; return }
            guard result == 200 else { completion(.failed) ; return }
            guard let drivers = data[1] as? [[String: Any]] else { completion(.failed) ; return }
            for driver in drivers {
                let bearing = driver["bearing"] as! Int
                let gender = driver["gender"] as! Int
                let id = driver["id"] as! Int
                let lat = driver["lat"] as! Double
                let lng = driver["lng"] as! Double
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                let frame = CGRect.init(x: 0, y: 0, width: 24, height: 50)
                let image = (Customer.shared.gender == .male) ? "car_men":"car_women"
                let customMarkerView = CustomMarkerView.init(frame: frame, markerType: .car, imageName: image)
                marker.iconView = customMarkerView
                let driver = Driver.init(bearing: bearing, gender: gender, id: id, lat: lat, lng: lng, gmsMarker:marker)
                self.drivers.append(driver)
            }
            completion(.success)
        }
    }
    
    func requestTaxi(fromLocation: CLLocationCoordinate2D, fromAddress: String, ToLocation :CLLocationCoordinate2D, toAddress: String,gender: Gender, priceId: String, completion: @escaping COMPLETION_HANDLER) {
        let type = (gender == .male) ? 0:1
        socket.emitWithAck("requestTaxi","\(fromLocation.latitude)","\(fromLocation.longitude)","\(ToLocation.latitude)","\(ToLocation.longitude)",fromAddress,toAddress,type,0,priceId).timingOut(after: 1) { (data) in
            guard let result = data[0] as? Int else { completion(.failed) ; return }
            guard result == 200 else { completion(.failed) ; return }
            completion(.success)
        }
    }
    
    func requestCity(completion: @escaping COMPLETION_HANDLER) {
        socket.emitWithAck("getActiveCities").timingOut(after: 1) { (data) in
            guard let result = data[0] as? Int else { completion(.failed) ; return }
            guard result == 200 else { completion(.failed) ; return }
            self.citys.removeAll()
            guard let citys = data[1] as? [[String: Any]] else { completion(.failed) ; return }
            for city in citys {
                let cityId = city["city_id"] as! Int
                let cityName = city["city_name"] as! String
                let lat = city["city_latitude"] as! Double
                let long = city["city_longitude"] as! Double
                let isDefault = city["is_default"] as! Int
                let newCity = City.init(cityID: cityId, cityName: cityName, cityLatitude: lat, cityLongitude: long, isDefault: isDefault)
                self.citys.append(newCity)
            }
            completion(.success)
        }
    }

    func inTravelRequest(completion: @escaping (_ type: InTravel,_ position: Driver?) -> Void) {
        guard let id = DataManager.shared.userInformation?.user.id else { return }
        socket.on("channel-rider-" + "\(id)") { (data, ack) in
            guard let string = data[0] as? String else { return }
            guard let dic = self.convertToDictionary(text: string) else { return }
            print(dic)
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: []) else { return }
            guard let decoder = try? JSONSerialization.jsonObject(with: jsonData, options: []) else { return }
            let json = decoder as! [String: Any]
            let activityStatus = json["activityStatus"] as! String
            let jsonDecoder = JSONDecoder()
            switch activityStatus {
                case "driverAccepted":
                    let city_id = json["city_id"] as? Int ?? 0
                    let id = json["id"] as? Int ?? 0
                    let car_plate_city_code = json["car_plate_city_code"] as? Int ?? 0
                    let car_color = json["car_color"] as? String ?? ""
                    let car_production_year = json["car_production_year"] as? Int ?? 0
                    let mobile_number = json["mobile_number"] as? Int ?? 0
                    let car_plate = json["car_plate"] as? String ?? ""
                    let car_image = json["car_image"] as? String ?? ""
                    let driver_image = json["driver_image"] as? String ?? ""
                    let first_name = json["first_name"] as? String ?? ""
                    let last_name = json["last_name"] as? String ?? ""
                    let rating = json["rating"] as? Double ?? 0.0
                    let car_name = json["car_name"] as? String ?? ""
                    let gender = json["gender"] as? Int ?? 0
                    let msgId = json["msgId"] as? String ?? ""
                    let submitDriver = SubmitDriver.init(id: id, cityID: city_id, carPlateCityCode: car_plate_city_code, carColor: car_color, carProductionYear: car_production_year, mobileNumber: mobile_number, carPlate: car_plate, carImage: car_image, driverImage: driver_image, firstName: first_name, lastName: last_name, rating: rating, carName: car_name, gender: gender, msgID: msgId, activityStatus: activityStatus)
                    if let mesgId = submitDriver.msgID {
                        self.sendMsgRequest(message: mesgId)
                    }
                    Customer.shared.submitDriver = submitDriver
                    NotificationCenter.default.post(name: DRIVER_ACCEPT_NOTIFT, object: nil)
                    completion(.driverAccepted,nil)
                case "startTravel":
                    guard let startTravel = try? jsonDecoder.decode(StartTravel.self, from: jsonData) else { return }
                    if let mesgId = startTravel.msgID {
                        self.sendMsgRequest(message: mesgId)
                    }
                    Customer.shared.startTravel = startTravel
                    LocalNotification.shared.sendNotification(message: "سفر شما شروع شد، آرزوی سفری خوش برای شما.", title: "شروع سفر")
                    NotificationCenter.default.post(name: START_TRAVEL_NOTIFY, object: nil)
                    completion(.startTravel,nil)
                case "cancelTravel":
                    Customer.shared.activeSetting = false
                    if let msgId = json["msgId"] as? String {
                        self.sendMsgRequest(message: msgId)
                    }
                    NotificationCenter.default.post(name: CANCEL_TRAVEL_NOTIFY, object: nil)
                    completion(.cancelTravel,nil)
                case "driverInLocation":
                    let msgId = json["msgId"] as! String
                    self.sendMsgRequest(message: msgId)
                    LocalNotification.shared.sendNotification(message: "راننده به مبدا انتخابی شما رسیده است !", title: "راننده رسید")
                    completion(.driverInLocation,nil)
                case "callRequest":
                    if let msgId = json["msgId"] as? String {
                        self.sendMsgRequest(message: msgId)
                    }
                    LocalNotification.shared.sendNotification(message: "راننده درخواست تماس برای شما ارسال کرده است !", title: "تماس با راننده")
                    completion(.callRequest,nil)
                case "travelInfoReceived":
                    if let msgId = json["msgId"] as? String {
                        self.sendMsgRequest(message: msgId)
                    }
                    let lat = json["lat"] as! Double
                    let lng = json["lng"] as! Double
                    let bearing = json["bearing"] as! Int
                    let clLocation = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(lat), longitude: CLLocationDegrees.init(lng))
                    let gmsMarker = GMSMarker.init(position: clLocation)
                    let gender = Customer.shared.submitDriver?.gender ?? Customer.shared.gender.rawValue
                    let id = Customer.shared.submitDriver?.id ?? 0
                    let driver = Driver.init(bearing: bearing, gender: gender, id: id, lat: lat, lng: lng, gmsMarker: gmsMarker)
                    print(driver)
                    Customer.shared.travelInfoReceived = driver
                    NotificationCenter.default.post(name: TRAVEL_INFO_RECIEVED_NOTIFY, object: nil)
                    completion(.travelInfoReceived,driver)
                case "finishedTaxi":
                    Customer.shared.activeSetting = false
                    guard let finishedTaxi = try? jsonDecoder.decode(FinishedTaxi.self, from: jsonData) else { return }
                    if let msgId = finishedTaxi.msgID {
                        self.sendMsgRequest(message: msgId)
                    }
                    Customer.shared.finishedTaxi = finishedTaxi
                    LocalNotification.shared.sendNotification(message: "سفر شما به اتمام رسید، امیدواریم سفر خوبی را با راننده ما تجربه کرده باشید", title: "پایان سفر")
                    NotificationCenter.default.post(name: FINISHED_TRAVEL_NOTIFIY, object: nil)
                    completion(.finishedTaxi,nil)
                default:
                    break
            }
        }
    }
    
    private func sendMsgRequest(message: String) {
        socket.emit("riderAckMsg", message)
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func sendReviewToDriver(rate: Double,review: String,completion: @escaping COMPLETION_HANDLER) {
        socket.emitWithAck("reviewDriver", rate,review).timingOut(after: 1.0) { (data) in
            guard let result = data[0] as? Int else { completion(.failed) ; return }
            guard result == 200 else { completion(.failed) ; return }
            completion(.success)
        }
    }
    
    func editProfileRequest(name: String, last: String, email: String, gendre: String, address: String, completion: @escaping COMPLETION_HANDLER) {
        let dict = ["email":email.lowercased(),
                    "first_name":name.lowercased(),
                    "gender":gendre.lowercased(),
                    "last_name":last.lowercased(),
                    "address":address.lowercased()
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else { completion(.json) ; return }
        guard let string = String.init(data: jsonData, encoding: .utf8) else { completion(.json) ; return }
        print(string)
        socket.emitWithAck("editProfile",string).timingOut(after: 1.0) { (data) in
            guard let result = data[0] as? Int else { completion(.failed) ; return }
            guard result == 200 else { completion(.failed) ; return }
            completion(.success)
        }
    }
    
    func sendProblemRequest(num: Int,type: String,comment: String,completion: @escaping COMPLETION_HANDLER) {
        socket.emitWithAck("RiderAppComplaint",DataManager.shared.userInformation!.user.id!,type,comment,num).timingOut(after: 1.0) { (data) in
            guard let result = data[0] as? Int else { completion(.failed) ; return }
            guard result == 200 else { completion(.failed) ; return }
            completion(.success)
        }
    }
    
    func sendTravelProblem(travelId: Int, subject: String, content: String , completion: @escaping COMPLETION_HANDLER) {
        socket.emitWithAck("writeComplaint", "\(travelId)",subject,content,DataManager.shared.userInformation!.user.id!).timingOut(after: 1.0) { (data) in
            print(data)
            guard let result = data[0] as? Int else { completion(.failed) ; return }
            guard result == 200 else { completion(.failed) ; return }
            completion(.success)
        }
    }
    
}
