//
//  ViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import UserNotifications
import NVActivityIndicatorView
import FirebaseRemoteConfig

class LoaderViewController: UIViewController, UNUserNotificationCenterDelegate {

    var activityIndicatorView: NVActivityIndicatorView!
    var remoteConfig: RemoteConfig!
    
    override func viewWillAppear(_ animated: Bool) {
        configureIndicator()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard PresentController.shared.IS_PRESENTED_WALK_TROUGHT_VC else {
            self.present(CarioPageViewController.showModal(), animated: true, completion: nil)
            return
        }
        guard PresentController.shared.IS_PRESENTED_REGISTERATION_VC else {
            self.present(RegistrationViewController.showModal(), animated: true, completion: nil)
            return
        }
        self.checkConnectionSocketIO()
        self.checkBaseURL()
    }
    
    // OBJC
    @objc func goToMainVC() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.performSegue(withIdentifier: TO_MAIN_VIEW_CONTROLLER_SEGUE, sender: nil)
        }
    }
    
    // Action
    @IBAction func unwindToLoaderViewController(_ segue: UIStoryboardSegue) {
        //
    }

    // Method
    func updateUI() {
        UNUserNotificationCenter.current().delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(goToMainVC), name: GO_TO_MAIN_FROM_LOADER_NOTIFY, object: nil)
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = RemoteConfigSettings.init(developerModeEnabled: true)
    }
    
    func configureIndicator() {
        let padding: CGFloat = 50.0
        let frame = CGRect(x: (UIScreen.main.bounds.width / 2) - (padding / 2), y: (self.view.bounds.height / 2) + 100, width: padding, height: padding)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.circleStrokeSpin, color: #colorLiteral(red: 0.2577471137, green: 0.3954381943, blue: 0.6748538613, alpha: 1), padding: padding)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func checkConnectionSocketIO() {
        print(BASE_URL)
        SocketConnection.instance.establishConnection()
        SocketConnection.instance.checkSocketConnection { (status) in
            if status == .success {
                self.getCitys()
                self.getInTravel()
                self.getTravelStatus()
            }
        }
    }

    func getCitys() {
        SocketConnection.instance.requestCity { (status) in
            if status == .success {
                //
            }
        }
    }
    
    func getInTravel() {
        SocketConnection.instance.inTravelRequest { (status, driver)  in
            //
        }
    }
    
    func getTravelStatus() {
        LoginService.instance.travelInfoRequest { (status) in
            if status == .success {
                guard let id = LoginService.instance.travelInfo?.setting?.iosAppVersion else { return }
                let version = Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)!
                if version < id {
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.presentUpdateViewController()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.performSegue(withIdentifier: TO_MAIN_VIEW_CONTROLLER_SEGUE, sender: nil)
                    }
                }
            }
        }
    }
    
    func checkBaseURL() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            if !SocketConnection.instance.isConnected {
                self.remoteConfigStatus()
            }
        }
    }
    
    func remoteConfigStatus() {
        remoteConfig.fetch(withExpirationDuration: 1.0) { (status, error) in
            if error != nil {
                return
            }
            if status == .success {
                print("Config fetched!")
                let baseURL = self.remoteConfig["server_address"].stringValue
                let isNeedURL = self.remoteConfig["use_server_address"].boolValue
                if isNeedURL {
                    BASE_URL = baseURL!
                    SocketConnection.instance.configSocket(baseURL: BASE_URL, token: Authentication.auth.token)
                    self.checkConnectionSocketIO()
                }
                self.remoteConfig.activateFetched()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    // Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
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

