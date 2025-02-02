//
//  AddressTableViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/25/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class AddressTableViewController: UIViewController, AddressTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    var initialTouchPoint = CGPoint.init(x: 0, y: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // OBJC
    @objc func tapButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func panGestureReconizerAction(_ gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: self.addressView)
        if gesture.state == .began {
            self.initialTouchPoint = touchPoint
        } else if gesture.state == .changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect.init(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.width, height: self.view.frame.height)
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            if touchPoint.y - initialTouchPoint.y > 50 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            }
        }
    }
    
    // Action
    func removeButtonPressed(cell: AddressTableViewCell) {
        if let _ = DataManager.shared.addresses {
            if let indexPath = tableView.indexPath(for: cell) {
                DataManager.shared.addresses!.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func agreeButtonPressed(_ sender: Any) {
        //
    }
    
    @IBAction func unwindToAddressTableViewController(_ segue: UIStoryboardSegue) {
        let source = segue.source as! AddressMapViewController
        if let marker = source.marker {
            let address = Address.init(name: marker.name, lat: "\(marker.position.latitude)", long: "\(marker.position.longitude)")
            if let _ = DataManager.shared.addresses {
                DataManager.shared.addresses!.append(address)
            } else {
                DataManager.shared.addresses = [address]
            }
        }
        self.tableView.reloadData()
    }
    
    // Method
    func updateUI() {
        let panGestureReconizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureReconizerAction(_:)))
        addressView.addGestureRecognizer(panGestureReconizer)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapButtonPressed))
        self.bgView.addGestureRecognizer(tapGesture)
    }
    
    

}

extension AddressTableViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ADDRESS_CELL, for: indexPath) as! AddressTableViewCell
        cell.delegate = self
        if let addresses = DataManager.shared.addresses {
            let address = addresses[indexPath.row]
            cell.configureCell(addressName: address.name, lat: address.lat, long: address.long)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let addresses = DataManager.shared.addresses else { return }
        let address = addresses[indexPath.row]
        DataManager.shared.address = address
        NotificationCenter.default.post(name: GO_MARKER_FOR_ADDRESS_NOTIFY, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
