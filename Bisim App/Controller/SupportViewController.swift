//
//  SupportViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/11/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController, UITextViewDelegate {
    
    var subject = ""
    var detail = ""
    var supportType: Support = .other
    
    struct PropertKeys {
        static let other = "مشکلات دیگر"
        static let app = "مشکلات اپلیکیشن"
    }

    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func agreeButtonPressed(_ sender: Any) {
        guard detailTextField.text != "" && detailTextField.text != "توضیحات را وارد کنید ..." else {
            let message = "لطفا مشکل خود را عنوان کنید !"
            self.presentWarningAlert(message: message)
            return
        }
        self.view.endEditing(true)
        var type = ""
        var num = 0
        if supportType == .other {
            type = PropertKeys.other
            num = 2
        } else {
            type = PropertKeys.app
            num = 1
        }
        SocketConnection.instance.sendProblemRequest(num: num, type: type, comment: detailTextField.text!) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        let message = "مشکل شما با موفقیت ثبت شد."
                        self.presentWarningAlert(message: message)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
    }
    
    // Method
    func updateUI() {
        self.dismissesKeyboardByTouch()
        self.detailTextField.font = UIFont.init(name: IRAN_SANS_MOBILE_FONT, size: 14)
        detailTextField.layer.cornerRadius = 5.0
        self.detailLabel.text = detail
        self.subjectLabel.text = subject
        detailTextField.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }

}
