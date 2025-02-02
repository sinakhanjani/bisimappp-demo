//
//  RequestViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import UserNotifications

class RequestViewController: UIViewController,UNUserNotificationCenterDelegate {

    @IBOutlet weak var lottieView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Objc
    @objc func dismissRequestViewController() {
        Customer.shared.activeSetting = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func driverAccept() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // Action
    @IBAction func deniedButtonPressed(_ sender: RoundedButton) {
        OrderService.instance.cancelTravel { (status) in
            Customer.shared.activeSetting = false
            if status == .success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    let message = "لطفا برای لغو سفر مجددا تلاش کنید !"
                    self.presentWarningAlert(message: message)
                }
            }
        }
    }
    
    // Method
    func updateUI() {
        UNUserNotificationCenter.current().delegate = self
        self.loadLottieJson(bundleName: "PinJump", lottieView: lottieView)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissRequestViewController), name: DISMISS_REQUEST_VIEW_CONTROLLER, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(driverAccept), name: DRIVER_ACCEPT_NOTIFT, object: nil)
    }

    // Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
    
    
    
}
