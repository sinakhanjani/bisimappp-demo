//
//  SideMenuTableViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/7/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import CDAlertView

class SideMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var namesLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        //
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = DataManager.shared.userInformation?.user {
            if let name = user.first_name, let lastName = user.last_name, lastName != "", name != "" {
                namesLabel.text = name + " " + lastName
            } else {
                if let number = user.mobile_number {
                    namesLabel.text = String(number)
                }
            }
        }
        if let balancePrice = LoginService.instance.travelInfo?.balanceAmount {
            let price = Int.decimalToInt(with: balancePrice)?.seperateByCama
            if let price = price {
                self.priceLabel.text = price
            } else {
                self.priceLabel.text = "0"
            }
        }
    }

    // Method
    func updateUI() {
        tableView.tableFooterView = UIView()
    }
    
    private func exitProfile() {
        let alert = CDAlertView(title: "توجه !", message: "آیا میخواهید از پروفایل کاربری خود خارج شوید ؟", type: CDAlertViewType.notification)
        alert.titleFont = UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 14)!
        alert.messageFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 14)!
        let done = CDAlertViewAction(title: "بله", font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white) { (action) -> Bool in
            Authentication.auth.logOutAuth()
            print("logout button pressed !")
            //self.performSegue(withIdentifier: UNWIND_SIDE_TO_LOADER_SEGUE, sender: nil)
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            return true
        }
        let cancel = CDAlertViewAction(title: "خیر", font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white, handler: nil)
        alert.add(action: done)
        alert.add(action: cancel)
        alert.show()
    }

    
    // TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = (indexPath.section, indexPath.row)
        switch selected {
        case (0,3):
            self.presentCreditUpViewController()
        case (2,1):
            let link = LoginService.instance.travelInfo?.setting?.appstoreIosLink ?? ""
            let message = "بیسیم اپ برنامه سفارش تاکسی آنلاین در سراسر استان بوشهر" + "\n" + "لینک دانلود :" + "\n" + link
            let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        case (2,2):
            if let url = URL(string: TELEGRAM_URL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        case (2,3):
            exitProfile()
        default:
            break
        }
    }
    
    
    
}
