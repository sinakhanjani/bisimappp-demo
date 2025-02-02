//
//  PassengerViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/23/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class PassengerViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var optionDriveView: RoundedView!
    @IBOutlet weak var routeTypeLabel: UILabel!
    @IBOutlet weak var passengerSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var passengerLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    
    var initialTouchPoint = CGPoint.init(x: 0, y: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // objc
    @objc func tapButtonPressed() {
        self.performSegue(withIdentifier: UNWIND_PASSENGER_TO_MAIN_SEGUE, sender: nil)
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
                self.performSegue(withIdentifier: UNWIND_PASSENGER_TO_MAIN_SEGUE, sender: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
        }
    }
    
    // Action
    @IBAction func switchButtonTapped(_ sender: Any) {
        if passengerSwitch.isOn {
            priceLabel.text = "مبلغ " + Customer.shared.totalPrice!.seperateByCama + " تومان"
            Customer.shared.passengerNumber = 0
            self.passengerLabel.text = "۳ نفر یا کمتر"
        } else {
            self.priceLabel.text = "مبلغ " + (Customer.shared.totalPrice! + 500).seperateByCama + " تومان"
            Customer.shared.passengerNumber = 1
            self.passengerLabel.text = "۴ نفر"

        }
    }
    

    // Method
    func updateUI() {
        let image = (Customer.shared.gender == .male) ? UIImage.init(named: "taxi_man"): UIImage.init(named: "taxi_woman")
        self.carImageView.image = image
        let panGestureReconizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureReconizerAction(_:)))
        optionDriveView.addGestureRecognizer(panGestureReconizer)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapButtonPressed))
        self.bgView.addGestureRecognizer(tapGesture)
        priceLabel.text = "مبلغ " + Customer.shared.totalPrice!.seperateByCama + " تومان"
        if Customer.shared.optionDrive.goAndBack == .goAndBack {
            self.routeTypeLabel.text = "رفت و برگشت"
        } else {
            self.routeTypeLabel.text = ""
        }
        if Customer.shared.optionDrive.stopWay == .stopWay {
            self.timeLabel.text = Customer.shared.time
        }
        self.passengerLabel.text = "۳ نفر یا کمتر"
    }

    
    
}
