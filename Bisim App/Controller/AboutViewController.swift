//
//  AboutViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/11/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //
    }

    @IBAction func shareButtonPressed(_ sender: Any) {
        let link = LoginService.instance.travelInfo?.setting?.appstoreIosLink ?? ""
        let message = "بیسیم اپ برنامه سفارش تاکسی آنلاین در سراسر استان بوشهر" + "\n" + "لینک دانلود :" + "\n" + link
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func instagramButtonPressed(_ sender: Any) {
        if let url = URL(string: INSTAGRAM_URL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @IBAction func telegramButtonPressed(_ sender: Any) {
        if let url = URL(string: TELEGRAM_URL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
}
