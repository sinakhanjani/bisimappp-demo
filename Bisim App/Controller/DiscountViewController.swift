//
//  DiscountViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/24/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class DiscountViewController: UIViewController {

    @IBOutlet weak var discountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Action
    @IBAction func agreeButtonPressed(_ sender: Any) {
        guard Customer.shared.markers.count >= 2 else {
            let message = "لطفا برای استفاده از کد تخفیف مقصد خود را وارد کنید !"
            self.presentWarningAlert(message: message)
            return
        }
        guard let code = discountTextField.text, discountTextField.text != "" else {
            let message = "لطفا کد تخفیف را وارد نمایید !"
            self.presentWarningAlert(message: message)
            return
        }
        var destinationName = ""
        if Customer.shared.optionDrive.secendPlace == .secendPlace {
            destinationName = Customer.shared.markers[2].name
        } else {
            destinationName = Customer.shared.markers[1].name
        }
        OrderService.instance.discountCodeCheck(code: code, destinationName: destinationName) { (status) in
            if status == .success {
                let message = "کد تخفیف به حساب شما افزوده شد."
                DispatchQueue.main.async {
                    self.presentWarningAlert(message: message)
                    self.performSegue(withIdentifier: UNWIND_DISCOUNT_VC_TO_MAIN_VC_SEGUE, sender: nil)
                }
            } else {
                let message = "کد تحفیف نامعتبر است !"
                DispatchQueue.main.async {
                    self.presentWarningAlert(message: message)
                }
            }
        }
    }
    
    // Method
    func updateUI() {
        self.dismissesKeyboardByTouch()
    }
    
    
}
