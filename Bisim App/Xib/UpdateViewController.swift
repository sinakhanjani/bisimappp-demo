
//
//  UpdateViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/9/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {
    
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Action
    @IBAction func downloadButtonPressed(_ sender: UIButton) {
        guard let sibappURL = LoginService.instance.travelInfo?.setting?.appstoreIosLink else { return }
        let url = URL.init(string: sibappURL)
        if let openURL = url {
            DispatchQueue.main.async {
                UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
            }
        }
        NotificationCenter.default.post(name: GO_TO_MAIN_FROM_LOADER_NOTIFY, object: nil)
        self.removeAnimate(duration: 0.3)
    }

    // Method
    func updateUI() {
        self.showAnimate(duration: 0.4)
        guard let iosForced = LoginService.instance.travelInfo?.setting?.iosIsForced else { return }
        if iosForced == 1 {
            self.downloadButton.alpha = 0
        } else {
            self.configureTouchXibViewController(bgView: bgView)
            self.downloadButton.alpha = 1
        }
    }

    
}
