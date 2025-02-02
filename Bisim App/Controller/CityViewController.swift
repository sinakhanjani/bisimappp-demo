//
//  CityViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/25/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cityView: UIView!
    
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
        let touchPoint = gesture.location(in: self.cityView)
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

    // Method
    func updateUI() {
        let panGestureReconizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureReconizerAction(_:)))
        cityView.addGestureRecognizer(panGestureReconizer)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapButtonPressed))
        self.bgView.addGestureRecognizer(tapGesture)
    }

    
    
}


extension CityViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SocketConnection.instance.citys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CITY_CELL, for: indexPath) as! AddressTableViewCell
        let city = SocketConnection.instance.citys[indexPath.row]
        cell.configureCell(addressName: city.cityName, lat: "\(city.cityLatitude)", long: "\(city.cityLongitude)")
        cell.deleteButton.alpha = 0.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = SocketConnection.instance.citys[indexPath.row]
        DataManager.shared.myCity = city
        NotificationCenter.default.post(name: GO_MARKER_FOR_ADDRESS_NOTIFY, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
