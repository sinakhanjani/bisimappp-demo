//
//  SubmitDriver.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/6/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct SubmitDriver: Codable {
    let id, cityID, carPlateCityCode: Int?
    let carColor: String?
    let carProductionYear, mobileNumber: Int?
    let carPlate, carImage, driverImage, firstName: String?
    let lastName: String?
    let rating: Double?
    let carName: String?
    let gender: Int?
    let msgID, activityStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case cityID = "city_id"
        case carPlateCityCode = "car_plate_city_code"
        case carColor = "car_color"
        case carProductionYear = "car_production_year"
        case mobileNumber = "mobile_number"
        case carPlate = "car_plate"
        case carImage = "car_image"
        case driverImage = "driver_image"
        case firstName = "first_name"
        case lastName = "last_name"
        case rating
        case carName = "car_name"
        case gender
        case msgID = "msgId"
        case activityStatus
    }
}
