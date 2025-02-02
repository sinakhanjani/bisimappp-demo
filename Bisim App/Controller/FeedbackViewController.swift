//
//  FeedbackViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    @IBOutlet weak var bigImageView: RoundedImageView!
    @IBOutlet weak var smallImageView: RoundedImageView!
    @IBOutlet weak var ratingStackView: RatingStackView!
    @IBOutlet weak var suggestionTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Actions
    @IBAction func agreeButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        guard suggestionTextField.text! != "" || ratingStackView.rating != 0 else {
            let message = "حداقل یک نظر یا امتیاز برای راننده ثبت کنید !"
            self.presentWarningAlert(message: message)
            return
        }
        let rate: Double = Double(ratingStackView.rating)
        var review: String = suggestionTextField.text!
        if suggestionTextField.text!.count > 244 {
            review = String(suggestionTextField.text!.dropFirst(254))
        }
        SocketConnection.instance.sendReviewToDriver(rate: rate, review: review) { (status) in
            if status == .success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: UNWIND_FEEDBACK_VC_TO_MAIN_VC_SEGUE, sender: nil)
                }
            }
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: UNWIND_FEEDBACK_VC_TO_MAIN_VC_SEGUE, sender: nil)
    }
    // Method
    func updateUI() {
        self.dismissesKeyboardByTouch()
        self.view.bindToKeyboard()
        if let driverDetails = Customer.shared.submitDriver {
            guard let firstName = driverDetails.firstName, let lastName = driverDetails.lastName else { return }
            nameLabel.text = firstName + " " + lastName
            if let largeImg = driverDetails.carImage {
                let url = URL.init(string: BASE_URL + largeImg)!
                SDWebImageManager.shared().loadImage(with: url, options: .highPriority, progress: nil) { (image, data, error, cache, success, url) in
                    self.bigImageView.image = image
                }
            }
            if let smallImg = driverDetails.driverImage {
                let url = URL.init(string: BASE_URL + smallImg)!
                print(url)
                SDWebImageManager.shared().loadImage(with: url, options: .highPriority, progress: nil) { (image, data, error, cache, success, url) in
                    self.smallImageView.image = image
                }
            }
        }
    }
    
    

}
