//
//  DateExtension.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/12/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

extension Date {
    
    static func convertToPersianDate(date: String) -> String {
        let range = date.startIndex...date.index(date.startIndex, offsetBy: 9)
        let string = date[range]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let enDate = dateFormatter.date(from: String(string))!
        dateFormatter.calendar = Calendar.init(identifier: .persian)
        return dateFormatter.string(from: enDate)
    }
}
