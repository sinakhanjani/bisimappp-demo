//
//  SendOrderViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/23/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class SendOrderViewController: UIViewController {

    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var optionDriveView: UIView!
    @IBOutlet weak var routeTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var passengerLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var firstAddressLabel: UILabel!
    @IBOutlet weak var secendPlaceNameLabel: UILabel!
    @IBOutlet weak var agreeButton: UIButton!
    
    @IBOutlet weak var secendDestinationStackView: UIStackView!
    @IBOutlet weak var routeTypeStackView: UIStackView!
    @IBOutlet weak var stopWayStackView: UIStackView!
    @IBOutlet weak var passengerStackView: UIStackView!
    
    var initialTouchPoint = CGPoint.init(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // objc
    @objc func tapButtonPressed() {
        self.performSegue(withIdentifier: UNWIND_SEND_ORDER_TO_MAIN_SEGUE, sender: nil)
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
                self.performSegue(withIdentifier: UNWIND_SEND_ORDER_TO_MAIN_SEGUE, sender: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
        }
    }
    
    @objc func driverAccept() {
        if Customer.shared.activeSetting {
            DispatchQueue.main.async {
                self.presentDriverViewController()
            }
        }
    }
    
    // Action
    
    @IBAction func agreeButtonPressed(_ sender: RoundedButton) {
        Customer.shared.activeSetting = true
        OrderService.instance.fullTravelRequest { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.presentRequestViewController()
                    }
                }
            })
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        Customer.shared.activeSetting = false
        self.performSegue(withIdentifier: UNWIND_SEND_ORDER_TO_MAIN_SEGUE, sender: nil)
    }
    
    @IBAction func unwindTOSendOrderViewController(_ segue: UIStoryboardSegue) {
        //
    }
    
    // Method
    func updateUI() {
        let image = (Customer.shared.gender == .male) ? UIImage.init(named: "taxi_man"): UIImage.init(named: "taxi_woman")
        self.carImageView.image = image
        let panGestureReconizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureReconizerAction(_:)))
        // optionDriveView.addGestureRecognizer(panGestureReconizer)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapButtonPressed))
        // self.bgView.addGestureRecognizer(tapGesture)
        if Customer.shared.optionDrive.goAndBack == .goAndBack {
            self.routeTypeLabel.text = "رفت و برگشت"
            self.routeTypeStackView.alpha = 1.0
        } else {
            self.routeTypeStackView.alpha = 0.0
            self.routeTypeLabel.text = ""
        }
        if Customer.shared.optionDrive.stopWay == .stopWay {
            self.timeLabel.text = Customer.shared.time
            self.stopWayStackView.alpha = 1.0
        } else {
            self.stopWayStackView.alpha = 0.0
        }
        self.firstAddressLabel.text = Customer.shared.markers[0].name
        if Customer.shared.optionDrive.secendPlace == .secendPlace {
            self.secendPlaceNameLabel.text = Customer.shared.markers[2].name
        } else {
            self.secendPlaceNameLabel.text = Customer.shared.markers[1].name
        }
        if Customer.shared.passengerNumber == 0 {
            priceLabel.text = "مبلغ " + Customer.shared.totalPrice!.seperateByCama
            self.passengerLabel.text = "۳ نفر یا کمتر"
        } else {
            priceLabel.text = "مبلغ " + (Customer.shared.totalPrice! + 500).seperateByCama
            self.passengerLabel.text = "۴ نفر"
        }
        if Customer.shared.gender == .male {
            self.serviceTypeLabel.text = "سرویس معمولی"
            self.agreeButton.backgroundColor = #colorLiteral(red: 0.1388182044, green: 0.7491472363, blue: 0.6214815974, alpha: 1)
            self.agreeButton.setTitle("سرویس معمولی", for: .normal)
        } else {
            self.serviceTypeLabel.text = "سرویس ویژه بانوان"
            self.agreeButton.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
            self.agreeButton.setTitle("سرویس بانوان", for: .normal)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(driverAccept), name: DRIVER_ACCEPT_NOTIFT, object: nil)
    }
    
    

}
