//
//  RegistrationViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var agreeButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
    }
    
    // Action
    @IBAction func agreeButtonPressed(_ sender: Any) {
        guard let phoneNumber = phoneTextField.text else { return }
        let number = removeDashFromNumber(numbers: phoneNumber)
        guard phoneNumberCondition(phoneNumber: number) else { return }
        self.startIndicatorAnimate()
        self.phoneTextField.resignFirstResponder()
        LoginService.instance.sendCodeRequest(mobileNumber: number) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        self.performSegue(withIdentifier: REGISTRATION_TO_CONFIRM_SEGUE, sender: nil)
                    }
                }
            })
        }
    }
    
    // Method
    func updateUI() {
        dismissesKeyboardByTouch()
        phoneTextField.keyboardType = .asciiCapableNumberPad
        self.phoneTextField.delegate = self
        self.phoneTextField.becomeFirstResponder()
    }
    
    static func showModal() -> RegistrationViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registrationViewController = storyBoard.instantiateViewController(withIdentifier: REGISTRATION_VIEW_CONTROLLER_ID) as! RegistrationViewController
        return registrationViewController
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 13
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        self.phoneTextField.text = formatPhone(textField.text!)
        if newString.length == maxLength {
            self.agreeButton.backgroundColor = #colorLiteral(red: 0.3254901961, green: 0.4274509804, blue: 0.9960784314, alpha: 1)
        }
        
        return newString.length <= maxLength
    }

    
    private func formatPhone(_ number: String) -> String {
        let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let format: [Character] = ["X", "X", "X", "X", "-", "X", "X", "X", "-", "X", "X", "X", "X"]
        
        var result = ""
        var index = cleanNumber.startIndex
        for ch in format {
            if index == cleanNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }

    func removeDashFromNumber(numbers: String) -> String {
        var result = ""
        for number in numbers {
            if number != "-" {
                result.append(number)
            }
        }
        return result
    }

}
