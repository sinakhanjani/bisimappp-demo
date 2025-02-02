//
//  StartTravel.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/6/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct StartTravel: Codable {
    let id, fkDriver, fkRider, cityID: Int?
    let status: Int?
    let origin, destination: String?
    let fromLat, fromLng, toLat, toLng: Double?
    let distanceBest, durationBest, travelDuration, travelDistance: Int?
    let requestTime: String?
    let fkTravelType, cost, rating, billType: Int?
    let discountID, usedDiscount, discountCredit: Int?
    let travelStart, log: String?
    let isHidden, commissionCost, returnStatus, returnCost: Int?
    let logReturnBack: String?
    let returnTravelDuration, returnTravelDistance: Int?
    let msgID, activityStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fkDriver = "fk_driver"
        case fkRider = "fk_rider"
        case cityID = "city_id"
        case status, origin, destination
        case fromLat = "from_lat"
        case fromLng = "from_lng"
        case toLat = "to_lat"
        case toLng = "to_lng"
        case distanceBest = "distance_best"
        case durationBest = "duration_best"
        case travelDuration = "travel_duration"
        case travelDistance = "travel_distance"
        case requestTime = "request_time"
        case fkTravelType = "fk_travel_type"
        case cost, rating
        case billType = "bill_type"
        case discountID = "discount_id"
        case usedDiscount = "used_discount"
        case discountCredit = "discount_credit"
        case travelStart = "travel_start"
        case log
        case isHidden = "is_hidden"
        case commissionCost = "commission_cost"
        case returnStatus = "return_status"
        case returnCost = "return_cost"
        case logReturnBack = "log_return_back"
        case returnTravelDuration = "return_travel_duration"
        case returnTravelDistance = "return_travel_distance"
        case msgID = "msgId"
        case activityStatus
    }
}
