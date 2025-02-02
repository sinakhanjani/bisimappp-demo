//
//  OrderMenuViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/9/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class OrderMenuViewController: UIViewController {

    @IBOutlet weak var orderButton: RoundedButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bottomMenuView: RoundedView!
    @IBOutlet weak var selectedGenderTaxiView: RoundedView!
    @IBOutlet weak var manStackView: UIStackView!
    @IBOutlet weak var womenStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // @objc
    @objc func dismissViewController(_ notify: NSNotification) {
        self.removeAnimate(duration: 1.0)
    }
    
    // Action
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: OPEN_SETTING_BUTTON_NOTIFY, object: nil)
    }
    
    @IBAction func taxiWomenButtonPressed(_ sender: UIButton) {
        self.womenStackView.alpha = 1.0
        self.manStackView.alpha = 0.3
        Customer.shared.gender = .female
    }
    
    @IBAction func taxiManButtonPressed(_ sender: UIButton) {
        self.womenStackView.alpha = 0.3
        self.manStackView.alpha = 1.0
        Customer.shared.gender = .male
    }
    
    @IBAction func discountButtonPressed(_ sender: RoundedButton) {
        //
    }
    
    @IBAction func orderServiceButtonPressed(_ sender: RoundedButton) {
        guard Customer.shared.markers.count <= 2 else {
            let message = "درخواست مجاز نیست، لطفا مقصد دوم را حذف کنید و مجددا از قسمت تنظیمات انتخاب نمایید !"
            self.presentWarningAlert(message: message)
            return
        }
        guard let travelPrice = OrderService.instance.travelPrice else {
            let message = "لطفا مجددا تلاش کنید !"
            self.presentWarningAlert(message: message)
            return
        }
        Customer.shared.activeSetting = false
        SocketConnection.instance.requestTaxi(fromLocation: Customer.shared.markers[0].position, fromAddress: Customer.shared.markers[0].name, ToLocation: Customer.shared.markers[1].position, toAddress: Customer.shared.markers[1].name, gender: Customer.shared.gender, priceId: travelPrice.priceId) { (status) in
            if status == .success {
                NotificationCenter.default.post(name: SEARCH_DRIVER_REQUEST_NOTIFY, object: nil)
            } else {
                let allMessage = "هیچ راننده ای فعلا در دسترس نیست !"
                let womenMessage = "هیچ راننده خانمی فعلا در دسترس نیست، شما میتوانید از سرویس همگانی استفاده نمایید."
                let message = (Customer.shared.gender == .male) ? allMessage:womenMessage
                self.presentWarningAlert(message: message)
            }
        }
    }
    
    // Method
    func updateUI() {
        self.showAnimate(duration: 0.6)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissViewController(_:)), name: REMOVE_ORDER_MENU_NOTIFY, object: nil)
        fetchPrice()
        if Customer.shared.gender == .male {
            self.womenStackView.alpha = 0.3
            self.manStackView.alpha  = 1.0
        } else {
            self.womenStackView.alpha = 1.0
            self.manStackView.alpha  = 0.3
        }
    }
    
    func fetchPrice() {
        incrementLabel()
        self.orderButton.isEnabled = false
        OrderService.instance.getPrice(from: Customer.shared.markers[0].position, to: Customer.shared.markers[1].position, optionService: .none) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    Customer.shared.firstPriceId = OrderService.instance.travelPrice?.priceId
                    Customer.shared.totalPrice = OrderService.instance.travelPrice?.price
                    DispatchQueue.main.async {
                        self.orderButton.isEnabled = true
                    }
                }
                if status == .area {
                    NotificationCenter.default.post(name: RESET_CUSTOMER_AND_MAP_DATA, object: nil)
                }
            })
        }
    }
    
    private var counter = 0
    private var timer: Timer!
    
    func incrementLabel() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.updateDelay), userInfo: nil, repeats: true)
    }
    
    @objc func updateDelay() {
        counter += 100
        self.priceLabel.text = counter.seperateByCama
        if let price = OrderService.instance.travelPrice?.price {
            self.priceLabel.text = price.seperateByCama
            timer.invalidate()
            counter = 0
            timer = nil
        }
    }
    
    
    
}
