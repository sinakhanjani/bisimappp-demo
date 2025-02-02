//
//  CustomerService.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/7/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class Customer {
    
    static var shared = Customer()
    
    var times: [String] {
        var num = 0
        var times = [String]()
        for _ in 0..<6 {
            let message = "از \(num) تا \(num + 5) دقیقه"
            num += 5
            times.append(message)
        }
        times.append("از \(30) تا \(45) دقیقه")
        times.append("از \(1) تا \(1.5) ساعت")
        times.append("از \(1.5) تا \(2) ساعت")
        times.append("از \(2) تا \(2.5) ساعت")
        times.append("از \(2.5) تا \(3) ساعت")
        times.append("از \(3) تا \(3.5) ساعت")
        times.append("از \(3.5) تا \(4) ساعت")
        
        return times
    }
    var time = ""
    
    var gender: Gender = .male {
        didSet {
            NotificationCenter.default.post(name: CHANGE_SERVICE_TYPE_NOTIFY, object: nil)
        }
    }
    var preOrder: Bool = false
    var markers = [Marker]()
    var secendPlaceName = SECEND_LABEL {
        didSet {
            NotificationCenter.default.post(name: SECEND_PLACE_NAME_CHANGED_NOTIFY, object: nil)
        }
    }
    var optionDrive: (secendPlace: OptionService, goAndBack: OptionService, stopWay: OptionService) = (secendPlace: .none, goAndBack: .none, stopWay: .none)
    var optionDriveMoney: (secendPlace: Int, goAndBack: Int, stopWay: Int) = (secendPlace: 0, goAndBack: 0, stopWay: 0)
    var totalPrice: Int?
    var firstPriceId: String?
    var secendPlaceId: String?
    var passengerNumber = 0
    var activeSetting = false
    var submitDriver: SubmitDriver?
    var startTravel: StartTravel?
    var finishedTaxi: FinishedTaxi?
    var travelInfoReceived: Driver?
    
    func resetCustomerData() {
        self.markers.removeAll()
        self.gender = .male
        self.preOrder = false
        self.secendPlaceName = SECEND_LABEL
        self.optionDrive.goAndBack = .none
        self.optionDrive.secendPlace = .none
        self.optionDrive.stopWay = .none
        optionDriveMoney = (secendPlace: 0, goAndBack: 0, stopWay: 0)
        totalPrice = nil
        time = ""
        activeSetting = false
        firstPriceId = nil
        secendPlaceId = nil
        passengerNumber = 0
        submitDriver = nil
        finishedTaxi = nil
        travelInfoReceived = nil
        LoginService.instance.travelInfo = nil
    }
    
    
}
