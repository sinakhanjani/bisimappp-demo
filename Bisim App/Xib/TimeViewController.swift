//
//  TimeViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func agreeButtonPressed(_ sender: Any) {
        OrderService.instance.getTimeAndPid(index: index) { (status) in
            if status == .success {
                DispatchQueue.main.async {
                    self.removeAnimate(duration: 0.4)
                    if let totalPrice = Customer.shared.totalPrice {
                        let total = totalPrice + Customer.shared.optionDriveMoney.stopWay
                        Customer.shared.totalPrice = total
                    }
                    Customer.shared.optionDrive.stopWay = .stopWay
                    if self.index == 0 {
                        Customer.shared.time = Customer.shared.times[self.index]
                    }
                    NotificationCenter.default.post(name: CHANGE_OPTION_DRIVE_VC_UI_NOTIFY, object: nil)
                }
            }
        }
    }
    
    // Method
    func updateUI() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.configureTouchXibViewController(bgView: bgView)
    }


}

extension TimeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Customer.shared.times.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let address = Customer.shared.times[row]
        
        return address
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        index = row
        Customer.shared.time = Customer.shared.times[index]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel.init()
            pickerLabel?.font = UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 16)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = Customer.shared.times[row]
        pickerLabel?.textColor = UIColor.darkGray
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    
}
