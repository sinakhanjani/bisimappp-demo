//
//  TopAddressWarningViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/25/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import UICheckbox_Swift

class TopAddressWarningViewController: UIViewController {

    @IBOutlet weak var showCheckBox: UICheckbox!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Action
    @IBAction func agreeButtonPressed(_ sender: Any) {
        self.presentAddressTableViewController()
        self.removeAnimate(duration: 0.4)
    }
    
    // Method
    func updateUI() {
        showCheckBox.isSelected = false
        configureTouchXibViewController(bgView: bgView)
        self.showAnimate(duration: 0.4)
        showCheckBox.onSelectStateChanged = { (checkbox, selected) in
            if selected {
                UserDefaults.standard.set(true, forKey: SHOW_ADDRESS_VC_KEY)
            } else {
                UserDefaults.standard.set(false, forKey: SHOW_ADDRESS_VC_KEY)
            }
        }
    }
    

}
