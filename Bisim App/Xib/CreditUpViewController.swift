//
//  CreditUpViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class CreditUpViewController: UIViewController {
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Actions
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        guard priceTextField.text != "" else {
            let message = "لطفا حداقل مبلغ هزار تومان را وارد کنید !"
            self.presentWarningAlert(message: message)
            return
        }
        guard let price = Int(priceTextField.text!) else { return }
        guard price > 999 else {
            let message = "لطفا حداقل مبلغ هزار تومان را وارد کنید !"
            self.presentWarningAlert(message: message)
            return
        }
        LoginService.instance.chargeCredit(mount: priceTextField.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    // Method
    func updateUI() {
        self.priceTextField.keyboardType = .asciiCapableNumberPad
        self.showAnimate(duration: 0.4)
        self.dismissesKeyboardByTouch()
        LoginService.instance.getCreditRequest { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.priceLabel.text = Int.decimalToInt(with: LoginService.instance.credit!)?.seperateByCama
                    }
                }
            })
        }
    }
    

}
