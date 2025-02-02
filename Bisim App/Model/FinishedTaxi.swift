//
//  FinishedTaxi.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/6/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct FinishedTaxi: Codable {
    let status: Int?
    let paid: Bool?
    let finalPay, time, distance: Int?
    let activityStatus, msgID: String?
    
    enum CodingKeys: String, CodingKey {
        case status, paid, finalPay, time, distance, activityStatus
        case msgID = "msgId"
    }
}
