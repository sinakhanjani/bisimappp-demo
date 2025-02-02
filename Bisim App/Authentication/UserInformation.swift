//
//  UserInformation.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var id: Int?
    var mobile_number: Int?
    var first_name: String?
    var last_name: String?
    var gender: String?
    var balance_amount: String?
    var image_address: String?
    var email: String?
    var address: String?
    
}

struct UserInformation: Codable {
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("userInfo").appendingPathExtension("inf")
    }

    var status: Int
    var user: User
    var token: String
    
    static func encode(userInfo: UserInformation, directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(userInfo) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> UserInformation? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode(UserInformation.self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
    
    
}
