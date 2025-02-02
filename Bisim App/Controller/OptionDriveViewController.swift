//
//  OptionDriveViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/9/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class OptionDriveViewController: UIViewController {


    @IBOutlet weak var agreeButton: RoundedButton!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var secendPlaceButton: UIButton!
    @IBOutlet weak var goAndBackButton: RoundedButton!
    @IBOutlet weak var stopWayButton: RoundedButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var optionDriveView: RoundedView!
    @IBOutlet weak var routeTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var initialTouchPoint = CGPoint.init(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Objc
    @objc func tapButtonPressed() {
       self.performSegue(withIdentifier: UNWIND_OPTION_TO_MAIN_SEGUE, sender: nil)
    }
    
    @objc func changeUIConfiguration() {
        incrementLabel()
        configureButtons()
    }
 
    @objc func panGestureReconizerAction(_ gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: self.optionDriveView)
        if gesture.state == .began {
            self.initialTouchPoint = touchPoint
        } else if gesture.state == .changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect.init(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.width, height: self.view.frame.height)
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            if touchPoint.y - initialTouchPoint.y > 50 {
                //self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: UNWIND_OPTION_TO_MAIN_SEGUE, sender: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
        }
    }
    
    @objc func secendPlaceNameChanged() {
        self.secendPlaceButton.setTitle("مقصد دوم : \(Customer.shared.secendPlaceName)", for: .normal)
    }
    
    // Action
    @IBAction func secendPlaceButtonPressed(_ sender: UIButton) {
        if let totalPrice = Customer.shared.totalPrice {
            Customer.shared.totalPrice = totalPrice - Customer.shared.optionDriveMoney.secendPlace
        }
        Customer.shared.optionDriveMoney.secendPlace = 0
        Customer.shared.optionDrive.secendPlace = .none // *
        NotificationCenter.default.post(name: ADD_SECEND_PLACE_NOTIFY, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goAndBackButtonPressed(_ sender: RoundedButton) {
        let optionDrive = Customer.shared.optionDrive.goAndBack
        if optionDrive == .none {
            let from = Customer.shared.markers.first!.position
            let to = Customer.shared.markers.last!.position
            self.agreeButton.isEnabled = false
            self.secendPlaceButton.isEnabled = false
            self.stopWayButton.isEnabled = false
            self.goAndBackButton.isEnabled = false
            OrderService.instance.getPrice(from: from, to: to, optionService: .goAndBack) { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        Customer.shared.optionDrive.goAndBack = .goAndBack
                        if let price = OrderService.instance.travelPrice?.price {
                            Customer.shared.optionDriveMoney.goAndBack = price
                            if let totalPrice = Customer.shared.totalPrice {
                                let total = totalPrice + price
                                Customer.shared.totalPrice = total
                            }
                        }
                        self.incrementLabel()
                        self.configureButtons()
                    }
                } else {
                    self.agreeButton.isEnabled = true
                    self.secendPlaceButton.isEnabled = true
                    self.stopWayButton.isEnabled = true
                    self.goAndBackButton.isEnabled = true
                }
            }
        } else {
            if let price = OrderService.instance.travelPrice?.price {
                if let totalPrice = Customer.shared.totalPrice {
                    let total = totalPrice - price
                    Customer.shared.totalPrice = total
                }
            }
            Customer.shared.optionDriveMoney.goAndBack = 0
            Customer.shared.optionDrive.goAndBack = .none
            configureButtons()
            incrementLabel()
        }
        
    }
    
    @IBAction func stopWayButtonPressed(_ sender: RoundedButton) {
        let optionDrive = Customer.shared.optionDrive
        if optionDrive.stopWay == .none {
            self.presentTimeViewController()
        } else {
            Customer.shared.optionDrive.stopWay = .none
            let delayPrice = Customer.shared.optionDriveMoney.stopWay
            if let totalPrice = Customer.shared.totalPrice {
                Customer.shared.optionDriveMoney.stopWay = 0
                let price = totalPrice - delayPrice
                Customer.shared.totalPrice = price
            }
            incrementLabel()
            self.stopWayButton.backgroundColor = .lightGray
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: RoundedButton) {
        //
    }
    
    @IBAction func unwindToOptopmDriveViewController(_ sender: UIStoryboardSegue) {
        
    }
    
    // Method
    func updateUI() {
        let image = (Customer.shared.gender == .male) ? UIImage.init(named: "taxi_man"): UIImage.init(named: "taxi_woman")
        self.carImageView.image = image
        let panGestureReconizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureReconizerAction(_:)))
        optionDriveView.addGestureRecognizer(panGestureReconizer)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapButtonPressed))
        self.bgView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(changeUIConfiguration), name: CHANGE_OPTION_DRIVE_VC_UI_NOTIFY, object: nil)
        self.secendPlaceButton.setTitle("مقصد دوم : \(Customer.shared.secendPlaceName)" , for: .normal)
        if Customer.shared.markers.count == 3 {
            Customer.shared.markers[2].name = Customer.shared.secendPlaceName
        }
        configureButtons()
        fetchSecendPlaceTravelPrice()
        NotificationCenter.default.addObserver(self, selector: #selector(secendPlaceNameChanged), name: SECEND_PLACE_NAME_CHANGED_NOTIFY, object: nil)
    }
    
    func configureButtons() {
        let optionDrive = Customer.shared.optionDrive
        if optionDrive.secendPlace != .none {
            self.secendPlaceButton.backgroundColor = #colorLiteral(red: 0.3238515854, green: 0.4271925092, blue: 0.9869003892, alpha: 1)
        } else {
            self.secendPlaceButton.backgroundColor = .lightGray
        }
        if optionDrive.goAndBack != .none {
            routeTypeLabel.text = "رفت و برگشت"
            self.goAndBackButton.backgroundColor = #colorLiteral(red: 0.3254901961, green: 0.4274509804, blue: 0.9882352941, alpha: 1)
        } else {
            routeTypeLabel.text = ""
            self.goAndBackButton.backgroundColor = .lightGray
        }
        if optionDrive.stopWay != .none {
            self.timeLabel.text = Customer.shared.time
            self.stopWayButton.backgroundColor = #colorLiteral(red: 0.3254901961, green: 0.4274509804, blue: 0.9882352941, alpha: 1)
        } else {
            self.timeLabel.text = ""
            self.stopWayButton.backgroundColor = .lightGray
        }
    }
    
    func fetchSecendPlaceTravelPrice() {
        guard Customer.shared.markers.count > 2 else {
            self.incrementLabel()
            return
        }
        let to = Customer.shared.markers[1].position
        let secend = Customer.shared.markers[2].position
        OrderService.instance.getPrice(from: to, to: secend, optionService: .none) { (status) in
            if status == .success {
                if let travelPrice = OrderService.instance.travelPrice {
                    Customer.shared.optionDriveMoney.secendPlace = travelPrice.price
                    Customer.shared.secendPlaceId = travelPrice.priceId
                    if let totalPrice = Customer.shared.totalPrice {
                        Customer.shared.totalPrice = totalPrice + travelPrice.price
                        DispatchQueue.main.async {
                            self.incrementLabel()
                            self.configureButtons()
                        }
                    }
                }
            } else if status == .area {
                let message = "مبداء یا مقصد خارج از محدوده میباشد !"
                DispatchQueue.main.async {
                    self.presentWarningAlert(message: message)
                    self.performSegue(withIdentifier: UNWIND_OPTION_TO_MAIN_SEGUE, sender: nil)
                }
            } else {
                let message = "درخواست با خطا مواجه شد، لطفا مجددا تلاش کنید !"
                DispatchQueue.main.async {
                    self.presentWarningAlert(message: message)
                    self.performSegue(withIdentifier: UNWIND_OPTION_TO_MAIN_SEGUE, sender: nil)
                }
            }
        }
    }

    
    // Timer animation
    private var counter = 0
    private var timer: Timer?
    
    func incrementLabel() {
        if let fromToLocationPrice = OrderService.instance.travelPrice?.price {
            counter = fromToLocationPrice - 100
        }
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.updateDelay), userInfo: nil, repeats: true)
    }
    
    @objc func updateDelay() {
        counter += 100
        self.agreeButton.isEnabled = false
        self.secendPlaceButton.isEnabled = false
        self.stopWayButton.isEnabled = false
        self.goAndBackButton.isEnabled = false
        self.priceLabel.text = "مبلـغ " + counter.seperateByCama + " تومـان"
        if let price = Customer.shared.totalPrice {
            if price == counter {
                self.priceLabel.text = "مبلـغ " + price.seperateByCama + " تومـان"
                timer?.invalidate()
                counter = 0
                self.agreeButton.isEnabled = true
                self.secendPlaceButton.isEnabled = true
                self.stopWayButton.isEnabled = true
                self.goAndBackButton.isEnabled = true
            }
        }
        if counter == 40000 {
            counter = 0
        }
    }
    
    
    
}
