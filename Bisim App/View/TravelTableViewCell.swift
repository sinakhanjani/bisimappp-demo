
//
//  TravelTableViewCell.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/11/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol TravelTableViewCellDelegate {
    func agreeButtonPressed(cell: TravelTableViewCell)
}

class TravelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var secendDestinationLabel: UILabel!
    @IBOutlet weak var returnPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var secendDestinationStackView: UIStackView!
    @IBOutlet weak var returnStackView: UIStackView!
    
    var delegate: TravelTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func sendToSupportButtonPressed(_ sender: RoundedButton) {
        delegate?.agreeButtonPressed(cell: self)
    }
    
    // Method
    func configureCell(date: String, travelDurationTime: Int, travelDistance: Int,secendDestinationPrice: Int?,returnPrice: Int?,price: Int,fromLocationAddress: String,endLocationAddress: String,driverName: String,showSecendStack:Bool,showReturnStack:Bool) {
        if showReturnStack {
            self.returnStackView.alpha = 1.0
        } else {
            self.returnStackView.alpha = 0.0
        }
        if showSecendStack {
            self.secendDestinationStackView.alpha = 1.0
        } else {
            self.secendDestinationStackView.alpha = 0.0
        }
        self.dateLabel.text = date
        self.timeLabel.text = String(travelDurationTime)
        self.distanceLabel.text = travelDistance.seperateByCama
        self.secendDestinationLabel.text = secendDestinationPrice?.seperateByCama
        self.returnPriceLabel.text = returnPrice?.seperateByCama
        self.priceLabel.text = price.seperateByCama
        self.fromLocationLabel.text = fromLocationAddress
        self.endLocationLabel.text = endLocationAddress
    }
    
}
