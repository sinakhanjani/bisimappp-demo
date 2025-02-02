//
//  ReceiptViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/12/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func creditUpButtonPressed(_ sender: RoundedButton) {
        self.presentCreditUpViewController()
    }
    
    // Method
    func updateUI() {
        self.startIndicatorAnimate()
        OrderService.instance.getPayListRequest { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }

}


extension ReceiptViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderService.instance.pay?.payments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PAY_CELL, for: indexPath) as! PayTableViewCell
        if let payments = OrderService.instance.pay?.payments {
            let payment = payments[indexPath.row]
            let date = Date.convertToPersianDate(date: payment.payDatetime!)
            cell.configureCell(price: payment.credit!, recip: payment.refID!, date: date)
        }
        return cell
    }
    
    
}
