//
//  AngryViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/11/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import DropDown

class AngryViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var problemButton: RoundedButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    private let selectedSupportType = DropDown()
    var subject = ""
    var data = ["بسته ای در خودرو جا گذاشته ام","طولانی شدن زمان انتظار","مسافر دیگری در خودرو بود","تفاوت در محل سوار شدن","نظافت خودرو، مشکلات فنی، تفاوت پلاک","عدم استفاده از سیستم تهویه مطبوع","مشکل با صدای ضبط و رادیو","نظافت راننده","مکالمه زیاد","عدم رعایت نکات ایمنی حین رانندگی","ادب و حفظ احترام","انتخاب مسیر اشتباه","مشکلی با هزینه سفر دارم","موارد دیگر"]
    var travelId: Int?
    
    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
    }
    
    // Action
    @IBAction func problemButtonPressed(_ sender: Any) {
        selectedSupportType.show()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.removeAnimate(duration: 0.4)
    }

    @IBAction func agreeButtonPressed(_ sender: Any) {
        guard subject != "" && descriptionTextField.text! != "" else {
            let message = "لطفا نوع مشکل و متنی درباره مورد مشکل وارد کنید !"
            self.presentWarningAlert(message: message)
            return
        }
        guard let travelId = travelId else { return }
        self.view.endEditing(true)
        SocketConnection.instance.sendTravelProblem(travelId: travelId, subject: subject, content: descriptionTextField.text!) { (status) in
            if status == .success {
                DispatchQueue.main.async {
                    self.removeAnimate(duration: 0.4)
                }
            }
        }
    }
    
    // Method
    func updateUI() {
        self.showAnimate(duration: 0.4)
        self.configureTouchXibViewController(bgView: bgView)
        self.dismissesKeyboardByTouch()
        configureDropDownButton()
    }
    
    func configureDropDownButton() {
        selectedSupportType.anchorView = problemButton
        selectedSupportType.bottomOffset = CGPoint(x: 0, y: problemButton.bounds.height)
        selectedSupportType.textFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 16)!
        selectedSupportType.dataSource = data
        self.selectedSupportType.selectionAction = { [weak self] (index, item) in
            self?.subject = self!.data[index]
        self?.problemButton.setTitle(self!.data[index], for: .normal)
        }
    }
    
    
    
}
