
//
//  PayTableViewCell.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/12/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class PayTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var recipLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //
    }
    
    func configureCell(price: Int, recip: String, date: String) {
        self.dateLabel.text = date
        self.priceLabel.text = price.seperateByCama
        self.recipLabel.text = recip
    }

    
}
