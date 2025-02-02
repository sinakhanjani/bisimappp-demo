//
//  CarioContentPageViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class CarioContentPageViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backButtonButton: UIButton!
    @IBOutlet weak var welcomeImageView: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var index = 0
    var imageFile = ""
    var detail = ""
    var subject = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        switch index {
        case 0...2:
            let pageViewController = parent as! CarioPageViewController
            pageViewController.forward(index: index)
        case 3:
            PresentController.shared.IS_PRESENTED_WALK_TROUGHT_VC = true
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        PresentController.shared.IS_PRESENTED_WALK_TROUGHT_VC = true
        dismiss(animated: true, completion: nil)
    }
    
    // Method
    func updateUI() {
        pageControl.currentPage = index
        welcomeImageView.image = UIImage.init(named: imageFile)
        subjectLabel.text = subject
        detailLabel.text = detail
        switch index {
        case 0...2:
            break
        case 3:
            break
        default:
            break
        }
    }


    
    
}
