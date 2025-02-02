//
//  PaymentMethodViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class PaymentMethodViewController: UIViewController {
    
    var paymentMethod: PaymentMethod = .cash

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var methodTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Action
    @IBAction func closeButtonPressed(_ sender: RoundedButton) {
        self.presentFeedbackViewController()
        self.removeAnimate(duration: 0.4)
    }
    
    // Method
    func updateUI() {
        self.showAnimate(duration: 0.4)
        configureUI()
    }
    
    func configureUI() {
        switch paymentMethod {
        case .cash:
            self.methodTypeLabel.text = "پرداخت نقدی"
            self.descriptionLabel.text = "لطفا هزینه را به صورت نقدی به راننده پرداخت کنید."
            self.imageView.image = UIImage.init(named: "cash")
            self.behindView.backgroundColor = #colorLiteral(red: 0.1450373828, green: 0.6504770517, blue: 0.3970197141, alpha: 1)
        case .bank:
            self.methodTypeLabel.text = "پرداخت اعتباری"
            self.descriptionLabel.text = "هزینه سفر به طور خودکار از اعتبار شما پرداخت خواهد شد."
            self.imageView.image = UIImage.init(named: "bank")
            self.behindView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        if let price = Customer.shared.totalPrice {
            self.priceLabel.text = price.seperateByCama + " " + "تومان"
        }
    }
    
    
    
}
