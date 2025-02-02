//
//  GoList.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/12/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct GoList: Codable {
    let status: Int?
    let gos: [Go]?
    
    enum CodingKeys: String, CodingKey {
        case gos = "travels"
        case status
    }
    
}

struct Go: Codable {
    let id, fkDriver, fkPassenger, cost: Int?
    let travel_duration: Int?
    let distanceBest, travelDistance: Int?
    let origin: String?
    let destination, requestTime: String?
    let returnStatus, returnCost: Int?
    let travelHasSecondDestination, secondTravelStatus, secondDestinationPrice, hasDelay: Int?
    let waitingPrice: Int?
    let driverFirstName: String?
    let driverLastName: String?
    let hasDdelay, hasSecondDestination, hasBackToOrigin: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fkDriver = "fk_driver"
        case fkPassenger = "fk_passenger"
        case cost
        case travel_duration
        case distanceBest = "distance_best"
        case travelDistance = "travel_distance"
        case origin, destination
        case requestTime = "request_time"
        case returnStatus = "return_status"
        case returnCost = "return_cost"
        case travelHasSecondDestination = "has_second_destination"
        case secondTravelStatus = "second_travel_status"
        case secondDestinationPrice = "second_destination_price"
        case hasDelay = "has_delay"
        case waitingPrice = "waiting_price"
        case driverFirstName = "driver_first_name"
        case driverLastName = "driver_last_name"
        case hasDdelay, hasSecondDestination, hasBackToOrigin
    }
}
