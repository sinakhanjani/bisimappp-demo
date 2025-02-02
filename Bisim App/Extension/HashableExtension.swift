//
//  File.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/19/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

extension Int {
    
    var seperateByCama: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let nsNumber = NSNumber(value: self)
        let number = formatter.string(from: nsNumber)!
        
        return number
    }
    
    static func decimalToInt(with string: String) -> Int? {
        let formatter = NumberFormatter()
        if let number = formatter.number(from: string) {
            
            return Int(truncating: number)
        }
        return nil
    }
    
}

extension String {
    
    var seperateByCama: String {
        guard self != "0" && self != "" && self != "0.00" && self != "0.0" else { return "صفـر" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let nsNumber = NSNumber(value: Int(self)!)
        let number = formatter.string(from: nsNumber)!
        
        return number
    }
    

    
}
