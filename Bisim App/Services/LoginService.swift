//
//  LoginService.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import GoogleMaps
import SocketIO

class LoginService {
    
    static let instance = LoginService()
    
    var mobile: String?
    var credit: String?
    var travelInfo: TravelInfo?
    
    func sendCodeRequest(mobileNumber: String, completion: @escaping COMPLETION_HANDLER) {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]
        guard let data = "phone=\(mobileNumber)".data(using: String.Encoding.utf8) else { completion(.data) ; return }
        guard let url = URL(string: BASE_URL + "rider/api/v2/login_rider_by_phone") else { completion(.server) ; return }
        let postData = NSMutableData(data: data)
        let request = NSMutableURLRequest(url: url,
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
                if json["success"].string != nil {
                    self.mobile = mobileNumber
                    completion(.success)
                }
                if json["error"].string != nil {
                    if let status = json["status"].int {
                        if status == 422 {
                            completion(.moreSendCode)
                        }
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func checkActivationCode(codeNumber: String, completion: @escaping COMPLETION_HANDLER) {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]
        guard let url = URL(string: BASE_URL + "rider/api/v2/sms/active_sms_code/\(codeNumber)") else { completion(.server) ; return }
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(.server)
            } else {
                guard let data = data else { completion(.data) ; return }
                guard let json = try? JSON.init(data: data) else { completion(.json) ; return }
                if json["user"].dictionary != nil {
                    guard let userInformation = try? JSONDecoder().decode(UserInformation.self, from: data) else { completion(.json) ; return }
                    UserInformation.encode(userInfo: userInformation, directory: UserInformation.archiveURL) // Save^ UserInformation
                    let token = json["token"].stringValue
                    Authentication.auth.authenticationUser(token: token, isLoggedIn: true)
                    SocketConnection.instance.configSocket(baseURL: BASE_URL, token: token)
                    completion(.success)
                } else {
                    completion(.wrongCode)
                }
            }
        })
        dataTask.resume()
    }
    
    func getCreditRequest(completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "rider/get_current_credit"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEADER).responseJSON { (resposne) in
            if resposne.result.error == nil {
                guard let data = resposne.data else { completion(.data) ; return }
                guard let json = try? JSON.init(data: data) else { completion(.json) ; return }
                if let _ = json["status"].int {
                    let credit = json["credit"].stringValue
                    self.credit = credit
                    completion(.success)
                } else {
                    completion(.server)
                }
            } else {
                completion(.failed)
            }
        }
    }
    
    func chargeCredit(mount: String) {
        guard let price = Int(mount) else { return }
        let url = URL.init(string: BASE_URL + "payment/mellat/\(price * 10)/\(Authentication.auth.token)")
        if let openURL = url {
            DispatchQueue.main.async {
                UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func travelInfoRequest(completion: @escaping COMPLETION_HANDLER) {
        let headers = [
            "Authorization": Authentication.auth.token,
            "Content-Type": "application/x-www-form-urlencoded"
            ]
        
        let postData = NSMutableData(data: "app_version=\(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)".data(using: String.Encoding.utf8)!)
        postData.append("&phone_model=\(getPlatformNSString())".data(using: String.Encoding.utf8)!)
        postData.append("&android_os=\(getOSInfo())".data(using: String.Encoding.utf8)!)
        print(getOSInfo())
        print(getPlatformNSString())
        print(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)
        let request = NSMutableURLRequest(url: NSURL(string: BASE_URL + "rider/active_travel_info")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                completion(.failed)
            } else {
                guard let data = data else { completion(.data) ; return }
                let decoder = JSONDecoder()
               print(String.init(data: data, encoding: .utf8))
                guard let travelInfo = try? decoder.decode(TravelInfo.self, from: data) else {
                    completion(.ban)
                    return
                }
                self.travelInfo = travelInfo
                completion(.success)
            }
        })
        
        dataTask.resume()
    }
    
    private func getOSInfo()->String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    private func getPlatformNSString() -> String {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
        let DEVICE_IS_SIMULATOR = true
        #else
        let DEVICE_IS_SIMULATOR = false
        #endif
        var machineSwiftString : String = ""
        if DEVICE_IS_SIMULATOR == true
        {
            // this neat trick is found at http://kelan.io/2015/easier-getenv-in-swift/
            if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                machineSwiftString = dir
                return machineSwiftString
            }
        } else {
            var size : size_t = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: Int(size))
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            machineSwiftString = String.init(cString: machine)
            return machineSwiftString
            
        }
        print("machine is \(machineSwiftString)")
        return machineSwiftString
    }
    
    func getBackCustomerData() {
        guard let travelInfo = self.travelInfo else { return }
        guard let travel = travelInfo.travel else { return }
        var totalPrice = 0
        if let cost = travel.cost {
            totalPrice += cost
        }
        if let waitingCost = travel.waitingPrice {
            totalPrice += waitingCost
        }
        if let secendPrice = travel.secondDestinationPrice {
            totalPrice += secendPrice
        }
        if let returnPrice = travel.returnCost {
            totalPrice += returnPrice
        }
        Customer.shared.totalPrice = totalPrice
        if let lat = travel.fromLat, let long = travel.fromLng, let origin = travel.origin {
            let fromCoordinate2d = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(lat), longitude: CLLocationDegrees.init(long))
            let gmsMarker = GMSMarker.init(position: fromCoordinate2d)
            let marker = Marker.init(markerType: .fromLocation, position: fromCoordinate2d, gmsMarker: gmsMarker, name: origin)
            Customer.shared.markers.append(marker)
        }
        
        if let lat = travel.toLat, let long = travel.toLng, let origin = travel.destination {
            let fromCoordinate2d = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(lat), longitude: CLLocationDegrees.init(long))
            let gmsMarker = GMSMarker.init(position: fromCoordinate2d)
            let marker = Marker.init(markerType: .toLocation, position: fromCoordinate2d, gmsMarker: gmsMarker, name: origin)
            Customer.shared.markers.append(marker)
        }
        if let lat = travel.secondToLat, let long = travel.secondToLng, let origin = travel.secondDestination {
            let fromCoordinate2d = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(lat), longitude: CLLocationDegrees.init(long))
            let gmsMarker = GMSMarker.init(position: fromCoordinate2d)
            let marker = Marker.init(markerType: .secendLocation, position: fromCoordinate2d, gmsMarker: gmsMarker, name: origin)
            Customer.shared.markers.append(marker)
        }
        let sumbitDriver = SubmitDriver.init(id: 0, cityID: 0, carPlateCityCode: travel.carPlateCityCode, carColor: travel.carColor, carProductionYear: travel.carProductionYear, mobileNumber: travel.mobileNumber, carPlate: travel.carPlate, carImage: travel.carImage, driverImage: travel.driverImage, firstName: travel.firstName, lastName: travel.lastName, rating: travel.rating, carName: travel.carName, gender: 0, msgID: "", activityStatus: "")
        Customer.shared.submitDriver = sumbitDriver
    }
    
    func getReferRequest(completion: @escaping (_ code: String?) -> Void) {
        let url = BASE_URL + "rider/get_rider_referral_code/" + "\(DataManager.shared.userInformation!.user.id!)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEADER).responseJSON { (resposne) in
            if resposne.result.error == nil {
                guard let data = resposne.data else { completion(nil) ; return }
                guard let json = try? JSON.init(data: data) else { completion(nil) ; return }
                if let status = json["status"].int {
                    if status == 200 {
                        let code = json["code"].stringValue
                        completion(code)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    
}
