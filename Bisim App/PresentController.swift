//
//  PresentController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

class PresentController {
    
    static let shared = PresentController()
    
    private let defaults = UserDefaults.standard
    
    public var IS_PRESENTED_REGISTERATION_VC: Bool {
        get {
            return defaults.bool(forKey: PRESENT_REGISTER_VC_KEY)
        }
        set {
            defaults.set(newValue, forKey: PRESENT_REGISTER_VC_KEY)
        }
    }

    public var IS_PRESENTED_WALK_TROUGHT_VC: Bool {
        get {
            return UserDefaults.standard.bool(forKey: PRESENT_PAGE_VIEW_CONTROLLER_KEY)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PRESENT_PAGE_VIEW_CONTROLLER_KEY)
        }
    }
    
}
