//
//  OrderService.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/19/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire
import SwiftyJSON

class OrderService {
    
    static let instance = OrderService()
    
    var travelPrice: TravelPrice?
    var timeWaiting: (pid: Int, price: Int)!
    var goList: GoList?
    var pay: Pay?
    
    private var number = 0
    
    func getPrice(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, optionService: OptionService ,completion: @escaping COMPLETION_HANDLER) {
        var url = BASE_URL + "rider/pre_travel_price/" + "\(from.latitude)" + "/" + "\(from.longitude)" + "/" + "\(to.latitude)" + "/" + "\(to.longitude)"
        if optionService == .goAndBack {
            url = BASE_URL + "rider/pre_travel_price/" + "\(to.latitude)" + "/" + "\(to.longitude)" + "/" + "\(from.latitude)" + "/" + "\(from.longitude)"
        }
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data) ; return }
                guard let json = try? JSON.init(data: data) else { completion(.json) ; return }
                let status = json["status"].intValue
                if status == 200 {
                    let price = json["price"].intValue
                    let priceId = json["priceId"].stringValue
                    let startName = json["start_name"].stringValue
                    let endName = json["end_name"].stringValue
                    let travelPrice = TravelPrice.init(price: price, priceId: priceId, startName: startName, endName: endName)
                    self.travelPrice = travelPrice
                    
                    completion(.success)
                } else {
                    completion(.area)
                }
            } else {
                completion(.failed)
            }
        }
    }
    
    func getTimeAndPid(index: Int, completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "rider/api/v2/time_waiting_price/\(index)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data) ; return }
                guard let json = try? JSON.init(data: data) else { completion(.json) ; return }
                let pid = json["pid"].intValue
                let price = json["price"].intValue
                self.timeWaiting = (pid: pid, price: price)
                Customer.shared.optionDriveMoney.stopWay = price
                completion(.success)
            } else {
                completion(.server)
            }
        }
    }
    
    func cancelTravel(completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "rider/travel_canceled/\(DataManager.shared.userInformation!.user.id!)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data) ; return }
                guard let json = try? JSON.init(data: data) else { completion(.json) ; return }
                let status = json["status"].intValue
                if status == 200 {
                    completion(.success)
                } else {
                    completion(.failed)
                }
            } else {
                completion(.server)
            }
        }
    }
    
    
    func fullTravelRequest(completion: @escaping COMPLETION_HANDLER) {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": Authentication.auth.token,
        ]
        //
        let postData = NSMutableData(data:"discountId=0".data(using: String.Encoding.utf8)!)
        postData.append("&pickLatitude=\(Customer.shared.markers[0].position.latitude)".data(using: String.Encoding.utf8)!)
        postData.append("&pickLongitude=\(Customer.shared.markers[0].position.longitude)".data(using: String.Encoding.utf8)!)
        postData.append("&pickupLocation=\(Customer.shared.markers[0].name)".data(using: String.Encoding.utf8)!)
        postData.append("&districtPriceId=\(Customer.shared.firstPriceId!)".data(using: String.Encoding.utf8)!)
        postData.append("&dropLatitude=\(Customer.shared.markers[1].position.latitude)".data(using: String.Encoding.utf8)!)
        postData.append("&dropLongitude=\(Customer.shared.markers[1].position.longitude)".data(using: String.Encoding.utf8)!)
        postData.append("&dropOffLocation=\(Customer.shared.markers[1].name)".data(using: String.Encoding.utf8)!)
        if Customer.shared.optionDrive.secendPlace == .secendPlace {
            postData.append("&hasSecondDestination=1".data(using: String.Encoding.utf8)!)
            postData.append("&secondDestinationLat=\(Customer.shared.markers[2].position.latitude)".data(using: String.Encoding.utf8)!)
            postData.append("&secondDestinationLng=\(Customer.shared.markers[2].position.longitude)".data(using: String.Encoding.utf8)!)
            postData.append("&secondDestinationName=\(Customer.shared.markers[2].name)".data(using: String.Encoding.utf8)!)
            postData.append("&secondDistrictPriceId=\(Customer.shared.secendPlaceId!)".data(using: String.Encoding.utf8)!)
            print("SECEND PLACE TRUE")
        }
        if Customer.shared.optionDrive.goAndBack == .goAndBack {
            postData.append("&hasBackToOrigin=1".data(using: String.Encoding.utf8)!)
        }
        if Customer.shared.optionDrive.stopWay == .stopWay {
            postData.append("&delayId=\(OrderService.instance.timeWaiting.pid)".data(using: String.Encoding.utf8)!)
            postData.append("&hasDelay=1".data(using: String.Encoding.utf8)!)
        }
        let taxiType = Customer.shared.gender == .male ? 0 : 1
        postData.append("&taxiType=\(taxiType)".data(using: String.Encoding.utf8)!)
        //
        let request = NSMutableURLRequest(url: NSURL(string: BASE_URL + "rider/api/v2/request_travel_with_option")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(.server)
            } else {
                guard let data = data else { completion(.data) ; return }
                guard let json = try? JSON.init(data: data) else { completion(.json) ; return }
                if let _ = json["drivers"].int {
                    completion(.success)
                } else {
                    if let status = json["status"].int {
                        if status == 404 {
                            completion(.noDriver)
                        } else {
                            completion(.failed)
                        }
                    } else {
                        completion(.failed)
                    }
                }
            }
        })

        dataTask.resume()
    }
        
    func discountCodeCheck(code: String, destinationName: String, completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "rider/validate_discount_code/" + "\(DataManager.shared.userInformation!.user.id!)/" + "\(code)/" + "\(destinationName)"
        guard let encodeURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { completion(.server) ; return }
        Alamofire.request(encodeURL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data) ; return }
                guard let json = try? JSON.init(data: data) else { completion(.json) ; return }
                let status = json["status"].intValue
                if status == 200 {
                    let balance = json["balance"].stringValue
                    let credit = json["credit"].intValue
                    let dtype = json["dtype"].intValue
                    completion(.success)
                } else {
                    completion(.invalidInput)
                }
            } else {
                completion(.failed)
            }
        }
    }
    
    func getOldOrderList(completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "rider/api/v2/travels"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data) ; return }
                let decoder = JSONDecoder()
                print(String.init(data: data, encoding: .utf8) as Any)
                guard let goList = try? decoder.decode(GoList.self, from: data) else { completion(.failed) ; return }
                self.goList = goList
                completion(.success)
            } else {
                completion(.server)
            }
        }
    }
    
    func getPayListRequest(completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "rider/get_rider_payments"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data) ; return }
                let decoder = JSONDecoder()
                guard let pay = try? decoder.decode(Pay.self, from: data) else { completion(.json) ; return }
                self.pay = pay
                completion(.success)
            } else {
                completion(.server)
            }
        }
    }
    
    
}
