//
//  UIViewControllerExtension.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import CDAlertView
import SideMenu
import Lottie

extension UIViewController {
    
    func webServiceAlert(withType type: Alert, escape: @escaping COMPLETION_HANDLER) {
        DispatchQueue.main.async {
            switch type {
            case .none:
                self.stopIndicatorAnimate()
                print("Alert Type: none")
                break
            case .success:
                print("Alert Type: success")
                escape(.success)
            case .failed:
                self.stopIndicatorAnimate()
                print("Alert Type: failed")
                let message = " !خطا در برقرارای ارتباط با سرور"
                self.presentWarningAlert(message: message)
            case .server:
                self.stopIndicatorAnimate()
                print("Alert Type: server")
                let message = "اطلاعات از سرور دریافت نشد !"
                self.presentWarningAlert(message: message)
            case .network:
                self.stopIndicatorAnimate()
                print("Alert Type: network")
                let message = "ارتباط شما با اینترنت قطغ میباشد !"
                self.presentWarningAlert(message: message)
            case .invalidInput:
                self.stopIndicatorAnimate()
                print("Alert Type: invalid Input textField")
                let message = "لطفا اطلاعات ورودی را بررسی نمایید"
                self.presentWarningAlert(message: message)
            case .duplicate:
                self.stopIndicatorAnimate()
                print("Alert Type: duplicate in server")
                let message = "با این شماره قبلا ثبت نام کرده اید، لطفا گزینه ورود را انتخاب کنید !"
                self.presentWarningAlert(message: message)
            case .json:
                self.stopIndicatorAnimate()
                print("Alert Type: json")
            case .data:
                self.stopIndicatorAnimate()
                print("Alert Type: data")
            case .noLogin:
                self.stopIndicatorAnimate()
                print("Alert Type: noLogin")
                let message = "این شماره قبلا در سیستم ثبت است، لطفا مجددا تلاش کنید !"
                self.presentWarningAlert(message: message)
            case .wrongCode:
                self.stopIndicatorAnimate()
                print("Alert Type: wringCode")
                let message = "کد تایید را اشتباه وارد کرده اید !"
                self.presentWarningAlert(message: message)
            case .moreSendCode:
                self.stopIndicatorAnimate()
                print("Alert Type: moreSendCode")
                let message = "بیش از دفعات مجاز درخواست کد فعالسازی داده اید، لطفا یک ساعت دیگر درخواست را ارسال کنید !"
                self.presentWarningAlert(message: message)
            case .area:
                print("Alert Type: area")
                self.stopIndicatorAnimate()
                let message = "مبدا یا مقصد خارج از محدوده میباشد !"
                self.presentWarningAlert(message: message)
                escape(.area)
            case .noDriver:
                print("Alert Type: noDriver")
                let allMessage = "هیچ راننده ای فعلا در دسترس نیست !"
                let womenMessage = "هیچ راننده خانمی فعلا در دسترس نیست، شما میتوانید از سرویس همگانی استفاده نمایید."
                let message = (Customer.shared.gender == .male) ? allMessage:womenMessage
                self.presentWarningAlert(message: message)
            case .ban:
                self.stopIndicatorAnimate()
                let message = "کاربر گرامی شما برای استفاده از برنامه بن شده اید !"
                self.presentWarningAlert(message: message)
                escape(.ban)
                print("Alert Type: ban")
                
            }
        }
    }
    
    
}

extension UIViewController {
    
    // ViewControllers
    func dismissesKeyboardByTouch() {
        let touch = UITapGestureRecognizer(target: self, action: #selector(touchPressed))
        self.view.addGestureRecognizer(touch)
    }
    
    @objc func touchPressed() {
        self.view.endEditing(true)
    }
    
    // Xibs ViewController
    func configureTouchXibViewController(bgView: UIView) {
        self.view.endEditing(true)
        let touch = UITapGestureRecognizer(target: self, action: #selector(dismissTouchPressed))
        bgView.addGestureRecognizer(touch)
    }
    
    @objc func dismissTouchPressed() {
        removeAnimate(duration: 0.4)
    }
    
}

extension UIViewController {
    
    func loadLottieJson(bundleName name: String, lottieView: UIView) {
        // Create Boat Animation
        let boatAnimation = LOTAnimationView(name: name)
        // Set view to full screen, aspectFill
        boatAnimation.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        boatAnimation.contentMode = .scaleAspectFill
        boatAnimation.frame = lottieView.bounds
        // Add the Animation
        lottieView.addSubview(boatAnimation)
        boatAnimation.loopAnimation = true
        boatAnimation.play()
    }
    
    func loadLottieFromURL(url: URL?, lottieView: UIView) {
        // Create Boat Animation
        guard let url = url else { return }
        let boatAnimation = LOTAnimationView.init(contentsOf: url)
        // Set view to full screen, aspectFill
        boatAnimation.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        boatAnimation.contentMode = .scaleAspectFill
        boatAnimation.frame = lottieView.bounds
        // Add the Animation
        lottieView.addSubview(boatAnimation)
        boatAnimation.loopAnimation = true
        boatAnimation.play()
    }
    
}

extension UIViewController {
    
    func presentWarningAlert(message: String) {
        let alert = CDAlertView(title: "توجه", message: message, type: CDAlertViewType.notification)
        alert.titleFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 15)!
        alert.messageFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 13)!
        let cancel = CDAlertViewAction(title: "باشه", font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white, handler: nil)
        alert.add(action: cancel)
        alert.show()
    }
    
    func phoneNumberCondition(phoneNumber number: String) -> Bool {
        guard !number.isEmpty else {
            let message = "شماره همراه خالی میباشد !"
            presentWarningAlert(message: message)
            return false
        }
        let startIndex = number.startIndex
        let zero = number[startIndex]
        guard zero == "0" else {
            let message = "شماره همراه خود را با صفر وارد کنید !"
            presentWarningAlert(message: message)
            return false
        }
        guard number.count == 11 else {
            let message = "شماره همراه میبایست یازده رقمی باشد !"
            presentWarningAlert(message: message)
            return false
        }
        
        return true
    }
    
}

extension UIViewController {
    
    func showAnimate(duration: Double) {
        self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: duration) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate(duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }
    
}

extension UIViewController {
    
    func startIndicatorAnimate() {
        let indicatorVC = IndicatorViewController()
        self.addChild(indicatorVC)
        indicatorVC.view.frame = self.view.frame
        self.view.addSubview(indicatorVC.view)
        indicatorVC.didMove(toParent: self)
    }
    
    func stopIndicatorAnimate() {
        NotificationCenter.default.post(name: DISMISS_INDICATOR_VC_NOTIFY, object: nil)
    }
    
}

extension UIViewController {
    
    func configureSideBar() {
        // Define the menus
        SideMenuManager.default.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        //Set up a cool background image for demo purposes
        // SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuBlurEffectStyle = .light
        SideMenuManager.default.menuFadeStatusBar = false
        // SideMenuManager.default.menuWidth = 0.7
        SideMenuManager.default.menuAnimationTransformScaleFactor = 1.0
        SideMenuManager.default.menuShadowOpacity = 0.7
        SideMenuManager.default.menuAnimationFadeStrength = 0.1
    }
    
}

extension UIViewController {
    
    func presentOrderMenuViewController() {
        let orderMainVC = storyboard?.instantiateViewController(withIdentifier: ORDER_MENU_VIEW_CONTROLLER_ID) as! OrderMenuViewController
        self.addChild(orderMainVC)
        orderMainVC.view.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - 200, width: UIScreen.main.bounds.width, height: 200)
        self.view.addSubview(orderMainVC.view)
        orderMainVC.didMove(toParent: self)
    }
    
    func presentOptionDriveViewController() {
        let optionDriverVC = storyboard?.instantiateViewController(withIdentifier: OPTION_DRIVE_VIEW_CONTROLLER_ID) as! UINavigationController
        optionDriverVC.modalTransitionStyle = .crossDissolve
        optionDriverVC.modalPresentationStyle = .overCurrentContext
        self.present(optionDriverVC, animated: true, completion: nil)
    }
    
    func presentServiceTypeViewController() {
        let serviceTypeVC = ServiceTypeViewController()
        self.addChild(serviceTypeVC)
        serviceTypeVC.view.frame = self.view.frame
        self.view.addSubview(serviceTypeVC.view)
        serviceTypeVC.didMove(toParent: self)
    }
    
    func presentTimeViewController() {
        let timeVC = TimeViewController()
        self.addChild(timeVC)
        timeVC.view.frame = self.view.frame
        self.view.addSubview(timeVC.view)
        timeVC.didMove(toParent: self)
    }
    
    func presentTopAdrressWarningViewController() {
        let topAddressVC = TopAddressWarningViewController()
        self.addChild(topAddressVC)
        topAddressVC.view.frame = self.view.frame
        self.view.addSubview(topAddressVC.view)
        topAddressVC.didMove(toParent: self)
//        let topAddressWarningVC = TopAddressWarningViewController()
//        topAddressWarningVC.modalTransitionStyle = .crossDissolve
//        topAddressWarningVC.modalPresentationStyle = .overCurrentContext
//        self.present(topAddressWarningVC, animated: true, completion: nil)
    }
    
    func presentAddressTableViewController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let addressTableVC = storyboard.instantiateViewController(withIdentifier: ADDRESS_TABLE_VC_ID) as! AddressTableViewController
        addressTableVC.modalTransitionStyle = .crossDissolve
        addressTableVC.modalPresentationStyle = .overCurrentContext
        self.present(addressTableVC, animated: true, completion: nil)
    }
    
    func presentCityViewController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let cityVC = storyboard.instantiateViewController(withIdentifier: CITY_VIEW_CONTROLLER_ID) as! CityViewController
        cityVC.modalTransitionStyle = .crossDissolve
        cityVC.modalPresentationStyle = .overCurrentContext
        self.present(cityVC, animated: true, completion: nil)
    }
    
    func presentCreditUpViewController() {
        let creditUpVC = CreditUpViewController()
        creditUpVC.modalTransitionStyle = .crossDissolve
        creditUpVC.modalPresentationStyle = .custom
        self.present(creditUpVC, animated: true, completion: nil)
    }
    
    func presentDissRouteViewController() {
        let dissRouteVC = driveModeStroyboard.instantiateViewController(withIdentifier: DISS_ROUTE_VIEW_CONTROLLER_ID) as! DissRouteViewController
        dissRouteVC.modalTransitionStyle = .crossDissolve
        dissRouteVC.modalPresentationStyle = .overCurrentContext
        self.present(dissRouteVC, animated: true, completion: nil)
    }
    
    func presentFeedbackViewController() {
        let feedbackVC = driveModeStroyboard.instantiateViewController(withIdentifier: FEEDBACK_VIEW_CONTROLLER_ID) as! FeedbackViewController
        feedbackVC.modalTransitionStyle = .crossDissolve
//        feedbackVC.modalPresentationStyle = .none
        self.present(feedbackVC, animated: true, completion: nil)
    }
    
    func presentDriverViewController() {
        let driverVC = driveModeStroyboard.instantiateViewController(withIdentifier: DRIVER_VIEW_CONTROLLER_ID) as! DriverViewController
        driverVC.modalTransitionStyle = .crossDissolve
        driverVC.modalPresentationStyle = .fullScreen
        self.present(driverVC, animated: true, completion: nil)
    }
    
    func presentPaymentMethodViewController(method: PaymentMethod) {
        let paymentVC = PaymentMethodViewController()
        paymentVC.paymentMethod = method
        self.addChild(paymentVC)
        paymentVC.view.frame = self.view.frame
        self.view.addSubview(paymentVC.view)
        paymentVC.didMove(toParent: self)
//        let paymentVC = PaymentMethodViewController()
//        paymentVC.paymentMethod = method
//        paymentVC.modalTransitionStyle = .crossDissolve
//        paymentVC.modalPresentationStyle = .overCurrentContext
//        self.present(paymentVC, animated: true, completion: nil)
    }
    
    func presentUpdateViewController() {
        let updateVC = UpdateViewController()
        self.addChild(updateVC)
        updateVC.view.frame = self.view.frame
        self.view.addSubview(updateVC.view)
        updateVC.didMove(toParent: self)
    }
    
    func presentAngryViewController(travelId: Int) {
        let angryVC = AngryViewController()
        angryVC.travelId = travelId
        self.addChild(angryVC)
        angryVC.view.frame = self.view.frame
        self.view.addSubview(angryVC.view)
        angryVC.didMove(toParent: self)
    }
    
    
}

extension UIViewController {
    
    func presentRequestViewController() {
        let requestVC = storyboard?.instantiateViewController(withIdentifier: REQUST_VIEW_CONTROLLER_ID) as! RequestViewController
        requestVC.modalTransitionStyle = .crossDissolve
        requestVC.modalPresentationStyle = .overCurrentContext
        self.present(requestVC, animated: true, completion: nil)
    }
    
    func removeRequestViewController() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}
