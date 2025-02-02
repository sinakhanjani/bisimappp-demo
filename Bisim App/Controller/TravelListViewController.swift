//
//  TravelListViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/11/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class TravelListViewController: UIViewController, TravelTableViewCellDelegate {
    
    func agreeButtonPressed(cell: TravelTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let id = OrderService.instance.goList!.gos![indexPath.row].id!
            self.presentAngryViewController(travelId: id)
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Method
    func updateUI() {
        self.startIndicatorAnimate()
        OrderService.instance.getOldOrderList { (status) in
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

extension TravelListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return OrderService.instance.goList?.gos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TRAVEL_CELL, for: indexPath) as! TravelTableViewCell
        cell.delegate = self
        if let gos = OrderService.instance.goList?.gos {
            let go = gos[indexPath.row]
            let hasSecend = go.hasSecondDestination ?? false
            let hasDelay = go.hasDdelay ?? false
            let hasBackToOrigin = go.hasBackToOrigin ?? false
            let date = Date.convertToPersianDate(date: go.requestTime!)
            cell.configureCell(date: date, travelDurationTime: go.travel_duration!, travelDistance: go.travelDistance!, secendDestinationPrice: go.secondDestinationPrice, returnPrice: go.returnCost, price: go.cost!, fromLocationAddress: go.origin!, endLocationAddress: go.destination!, driverName: go.driverFirstName!, showSecendStack: hasSecend, showReturnStack: hasBackToOrigin)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    
}
