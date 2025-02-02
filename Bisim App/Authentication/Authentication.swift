//
//  Authentication.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

//
//  File.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//
import Foundation

class Authentication {
    
    static let auth = Authentication()
    
    enum Platform: Int {
        case none, android, ios
    }
    
    let defaults = UserDefaults.standard
    
    private var _isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: IS_LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: IS_LOGGED_IN_KEY)
        }
    }
    private var _token: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }

    public var isLoggedIn: Bool {
        return _isLoggedIn
    }
    
    public var token: String {
        return _token
    }

    public func authenticationUser(token: String, isLoggedIn: Bool) {
        self._token = token
        self._isLoggedIn = isLoggedIn
    }
    
    public func logOutAuth() {
        SocketConnection.instance.closeConnection()
        self._isLoggedIn = false
        self._token = ""
        let userInformation = UserInformation.init(status: 0, user: User(), token: "")
        UserInformation.encode(userInfo: userInformation, directory: UserInformation.archiveURL)
        PresentController.shared.IS_PRESENTED_REGISTERATION_VC = false
        PresentController.shared.IS_PRESENTED_WALK_TROUGHT_VC = false
        UserDefaults.standard.set(false, forKey: SHOW_ADDRESS_VC_KEY)
        DataManager.shared.addresses = [Address]()
        DataManager.shared.myCity = nil
        Customer.shared.resetCustomerData()
    }
    
    
}
