//
//  TravelInfo.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/8/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//
//

struct TravelInfo: Codable {
    let travel: Travel?
    let setting: Setting?
    let balanceAmount: String?
    
    enum CodingKeys: String, CodingKey {
        case travel, setting
        case balanceAmount = "balance_amount"
    }
}

struct Setting: Codable {
    let id, appType, appVersion, iosAppVersion: Int?
    let isForced, iosIsForced: Int?
    let directLink: String?
    let iosDirectLink: String?
    let cafebazarLink: String?
    let appstoreIosLink: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case appType = "app_type"
        case appVersion = "app_version"
        case iosAppVersion = "ios_app_version"
        case isForced = "is_forced"
        case iosIsForced = "ios_is_forced"
        case directLink = "direct_link"
        case iosDirectLink = "ios_direct_link"
        case cafebazarLink = "cafebazar_link"
        case appstoreIosLink = "appstore_ios_link"
    }
}

struct Travel: Codable {
    let id, cost, status: Int?
    let origin, destination: String?
    let fromLat, fromLng: Double?
    let travelID, travelHasSecondDestination: Int?
    let secondFromLat, secondFromLng: Double?
    let secondOrigin, secondDestination: String?
    let secondToLat, secondToLng: Double?
    let secondTravelStatus, secondDurationBest, secondTravelDuration, secondDistanceBest: Int?
    let secondTravelDistance, secondDestinationPrice: Int?
    let secondLog: String?
    let travelHasDelay, waitingPrice, timeIndex, delayPriceID: Int?
    let toLat, toLng: Double?
    let returnStatus, returnCost: Int?
    let firstName, lastName: String?
    let mobileNumber: Int?
    let carName, carColor: String?
    let carProductionYear: Int?
    let carPlate, carImage: String?
    let carPlateCityCode: Int?
    let driverImage: String?
    let rating: Double?
    let isEnabled: Int?
    let balanceAmount: String?
    let creditPay, hasDelay: Bool?
    let timeLabel: String?
    let hasSecondDestination, hasBackToOrigin: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, cost, status, origin, destination
        case fromLat = "from_lat"
        case fromLng = "from_lng"
        case travelID = "travel_id"
        case travelHasSecondDestination = "has_second_destination"
        case secondFromLat = "second_from_lat"
        case secondFromLng = "second_from_lng"
        case secondOrigin = "second_origin"
        case secondDestination = "second_destination"
        case secondToLat = "second_to_lat"
        case secondToLng = "second_to_lng"
        case secondTravelStatus = "second_travel_status"
        case secondDurationBest = "second_duration_best"
        case secondTravelDuration = "second_travel_duration"
        case secondDistanceBest = "second_distance_best"
        case secondTravelDistance = "second_travel_distance"
        case secondDestinationPrice = "second_destination_price"
        case secondLog = "second_log"
        case travelHasDelay = "has_delay"
        case waitingPrice = "waiting_price"
        case timeIndex = "time_index"
        case delayPriceID = "delay_price_id"
        case toLat = "to_lat"
        case toLng = "to_lng"
        case returnStatus = "return_status"
        case returnCost = "return_cost"
        case firstName = "first_name"
        case lastName = "last_name"
        case mobileNumber = "mobile_number"
        case carName = "car_name"
        case carColor = "car_color"
        case carProductionYear = "car_production_year"
        case carPlate = "car_plate"
        case carImage = "car_image"
        case carPlateCityCode = "car_plate_city_code"
        case driverImage = "driver_image"
        case rating
        case isEnabled = "is_enabled"
        case balanceAmount = "balance_amount"
        case creditPay = "credit_pay"
        case hasDelay
        case timeLabel = "time_label"
        case hasSecondDestination, hasBackToOrigin
    }
}
