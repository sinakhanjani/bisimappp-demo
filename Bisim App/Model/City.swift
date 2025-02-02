//
//  City.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/25/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct City: Codable {
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("city").appendingPathExtension("cs")
    }
    
    let cityID: Int
    let cityName: String
    let cityLatitude, cityLongitude: Double
    let isDefault: Int
    
    enum CodingKeys: String, CodingKey {
        case cityID = "city_id"
        case cityName = "city_name"
        case cityLatitude = "city_latitude"
        case cityLongitude = "city_longitude"
        case isDefault = "is_default"
    }
    
    static func encode(city: City, directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(city) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> City? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode(City.self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
    
}
