//
//  ServiceTypeViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ServiceTypeViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var womenStackView: UIStackView!
    @IBOutlet weak var manStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func taxiWomenButtonPressed(_ sender: UIButton) {
        self.womenStackView.alpha = 1.0
        self.manStackView.alpha = 0.3
        Customer.shared.gender = .female
        self.removeAnimate(duration: 0.4)
    }
    
    @IBAction func taxiManButtonPressed(_ sender: UIButton) {
        self.womenStackView.alpha = 0.3
        self.manStackView.alpha = 1.0
        Customer.shared.gender = .male
        self.removeAnimate(duration: 0.4)
    }
    
    // Method
    func updateUI() {
        self.showAnimate(duration: 0.4)
        self.configureTouchXibViewController(bgView: self.bgView)
        if Customer.shared.gender == .male {
            self.womenStackView.alpha = 0.3
            self.manStackView.alpha  = 1.0
        } else {
            self.womenStackView.alpha = 1.0
            self.manStackView.alpha  = 0.3
        }
    }
    

}
