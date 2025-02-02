//
//  ReferViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/11/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ReferViewController: UIViewController {

    @IBOutlet weak var referCodeLabel: UILabel!
    
    var referCode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func agreeButtonPressed(_ sender: Any) {
        let message = "با این لینک تو بیسیم اپ ثبت ‌نام کن و اعتبار رایگان بگیر. با بیسیم اپ می‌تونی خیلی راحت هر جای استان بوشهر هستی درخواست خودرو رو بدی." + "\n" + "\(BASE_URL)#/referral/\(referCode)"
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    // Method
    func updateUI() {
        LoginService.instance.getReferRequest { (code) in
            if let code = code {
                DispatchQueue.main.async {
                    self.referCode = code
                    self.referCodeLabel.text = code
                }
            }
        }
    }
    
    

}
