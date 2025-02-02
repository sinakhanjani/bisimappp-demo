//
//  SupportMainViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/11/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class SupportMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Actions

    
    // Method
    func updateUI() {
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 14)!], for: .normal)
        backButton.tintColor = UIColor.darkGray
        navigationItem.backBarButtonItem = backButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == APP_SUPOORT_SEGUE {
            let destination = segue.destination as! SupportViewController
            destination.subject = "مشکلات اپلیکیشن"
            destination.detail = "اگر مشکلی در اپلیکیشن مثل عدم بارگزاری نقشه، بسته شدن اپلیکیشن و ... دارید باعث افتخار ماست که اون را با ما در میان بگذارید"
            destination.supportType = .app
        }
        if segue.identifier == OTHER_SUPPORT_SEGUE {
            let destination = segue.destination as! SupportViewController
            destination.subject = "موارد دیگر"
            destination.detail = "هر مشکلی که فکر میکنید نیاز به پیگیری ما و نیاز به اصلاح دارد برای ما ارسال کنید"
            destination.supportType = .other
        }
        if segue.identifier == TRAVEL_SUPPORT_SEGUE {
            let destination = segue.destination as! TravelListViewController
            destination.title = "لیست سفرها"
        }
    }

}
