//
//  VerificationViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var agreeButton: RoundedButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet var underLineViews: [UIView]!
    @IBOutlet weak var phoneLabel: UILabel!
    
    enum Line {
        case gray, green
    }
    
    var isLineGreen = [Line](repeating: .gray, count: 6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func codeTextFieldValueChanged(_ sender: UITextField) {
        let attributedString = NSMutableAttributedString(string: codeTextField.text!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 21.4, range: NSMakeRange(0, codeTextField.text!.count))
        //attributedString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, codeTextField.text!.count))
        //attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, codeTextField.text!.count))
        codeTextField.attributedText = attributedString
        if sender.text!.count == 6 {
            sender.resignFirstResponder()
        }
        /*
        let index = sender.text!.count - 1
        print(index)
        if index >= 0 {
            if isLineGreen[index] == .gray {
                self.underLineViews[index].backgroundColor = #colorLiteral(red: 0.09138926119, green: 0.8540715575, blue: 0.5466291904, alpha: 1)
                isLineGreen[index] = .green
            } else {
                self.underLineViews[index].backgroundColor = #colorLiteral(red: 0.6061837673, green: 0.6066573262, blue: 0.6062571406, alpha: 1)
                isLineGreen[index] = .gray
            }
        }
         */
    }
    
    @IBAction func agreeButtonPressed(_ sender: RoundedButton) {
        guard let codeNumber = codeTextField.text else { return }
        guard !codeNumber.isEmpty else {
            let messge = "کد تایید را وارد نمایید"
            self.presentWarningAlert(message: messge)
            return
        }
        guard codeNumber.count == 6 else {
            let message = "کد تایید میبایست شش رقمی باشد !"
            self.presentWarningAlert(message: message)
            return
        }
        self.startIndicatorAnimate()
        LoginService.instance.checkActivationCode(codeNumber: codeNumber) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        print("successfully login authentication")
                        PresentController.shared.IS_PRESENTED_REGISTERATION_VC = true
                        self.performSegue(withIdentifier: UNWIND_VERIFICATION_TO_LOADER_SEGUE, sender: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func sendCodeAgainButtonPressed(_ sender: Any) {
        guard let mobileNumber = LoginService.instance.mobile else { return }
        self.startIndicatorAnimate()
        self.view.endEditing(true)
        LoginService.instance.sendCodeRequest(mobileNumber: mobileNumber) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        let message = "کد تایید ارسال شد !"
                        self.presentWarningAlert(message: message)
                    }
                }
            })
        }
    }
    
    @IBAction func wrongNumberButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Method
    func updateUI() {
        self.dismissesKeyboardByTouch()
        codeTextField.keyboardType = .asciiCapableNumberPad
        self.codeTextField.delegate = self
        self.codeTextField.becomeFirstResponder()
        if let phone = LoginService.instance.mobile {
            self.phoneLabel.text = phone
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        let index = textField.text!.count
        if index >= 0 {
            if isLineGreen[index] == .gray {
                self.underLineViews[index].backgroundColor = #colorLiteral(red: 0.09138926119, green: 0.8540715575, blue: 0.5466291904, alpha: 1)
                isLineGreen[index] = .green
            } else {
                self.underLineViews[index].backgroundColor = #colorLiteral(red: 0.6061837673, green: 0.6066573262, blue: 0.6062571406, alpha: 1)
                isLineGreen[index] = .gray
            }
        }
        if textField.text!.count == 0 {
            return true
        }
        if newString.length == maxLength {
            self.agreeButton.backgroundColor = #colorLiteral(red: 0.3254901961, green: 0.4274509804, blue: 0.9960784314, alpha: 1)
        }

        return newString.length <= maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isLineGreen = [Line](repeating: .gray, count: 6)
        for view in underLineViews {
            view.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
}
