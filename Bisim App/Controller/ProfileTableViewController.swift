//
//  ProfileTableViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/12/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var familyTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var gendreSwitch: UISwitch!
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Action
    @IBAction func agreeButtonPressed(_ sender: Any) {
        let gendre: String = gendreSwitch.isOn ? "male":"female"
        self.view.endEditing(true)
        SocketConnection.instance.editProfileRequest(name: nameTextField.text!, last: familyTextField.text!, email: emailTextField.text!, gendre: gendre, address: addressTextField.text!) { (status) in
            if status == .success {
                let oldUser = DataManager.shared.userInformation!.user
                let user = User.init(id: oldUser.id, mobile_number: oldUser.mobile_number, first_name: self.nameTextField.text!, last_name: self.familyTextField.text, gender: gendre, balance_amount: oldUser.balance_amount, image_address: oldUser.image_address, email: self.emailTextField.text, address: self.addressTextField.text)
                let userInformation = UserInformation.init(status: 200, user: user, token: Authentication.auth.token)
                DataManager.shared.userInformation = userInformation
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func gendreValueChanged(_ sender: UISwitch) {
        //
    }
    
    // Method
    func updateUI() {
        guard let user = DataManager.shared.userInformation?.user else { return }
        if let phone = DataManager.shared.userInformation?.user.mobile_number {
            phoneLabel.text = String(phone)
        }
        nameTextField.text = user.first_name ?? ""
        familyTextField.text = user.last_name ?? ""
        emailTextField.text = user.email ?? ""
        addressTextField.text = user.address ?? ""
        if let gendre = user.gender {
            if gendre == "male" {
                gendreSwitch.isOn = true
            } else {
                gendreSwitch.isOn = false
            }
        }
        registerForKeyboardNotifications()
    }
    
    // KEYBOARD
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWasShown(_:)),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
        guard let info = notificiation.userInfo,
            let keyboardFrameValue =
            info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
            else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 45.0, right: 0.0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    
}
