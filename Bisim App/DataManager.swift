//
//  DataManager.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    // User Information
    public var userInformation: UserInformation? {
        get {
            return UserInformation.decode(directory: UserInformation.archiveURL)
        }
        set {
            if let encode = newValue {
                UserInformation.encode(userInfo: encode, directory: UserInformation.archiveURL)
            }
        }
    }
    
    public var address: Address?
    public var addresses: [Address]? {
        get {
            return Address.decode(directory: Address.archiveURL)
        }
        set {
            if let encode = newValue {
                Address.encode(address: encode, directory: Address.archiveURL)
            }
        }
    }

    public var myCity: City? {
        get {
            return City.decode(directory: City.archiveURL)
        }
        set {
            if let encode = newValue {
                City.encode(city: encode, directory: City.archiveURL)
            }
        }
    }
    
    
}
