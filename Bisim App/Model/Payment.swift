//
//  Payment.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/12/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct Pay: Codable {
    let status: Int?
    let payments: [Payment]?
}

struct Payment: Codable {
    let id, riderID: Int?
    let refID, saleReferenceID: String?
    let status: Int?
    let payMsg: String?
    let credit: Int?
    let cardNumber: String?
    let payDatetime: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case riderID = "rider_id"
        case refID = "ref_id"
        case saleReferenceID = "sale_reference_id"
        case status
        case payMsg = "pay_msg"
        case credit
        case cardNumber = "card_number"
        case payDatetime = "pay_datetime"
    }
}
