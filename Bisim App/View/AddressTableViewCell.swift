//
//  AddressTableViewCell.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/25/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol AddressTableViewCellDelegate {
    func removeButtonPressed(cell: AddressTableViewCell)
}

class AddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adrressNameLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: AddressTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        delegate?.removeButtonPressed(cell: self)
    }
    
    func configureCell(addressName:String, lat: String, long: String) {
        self.adrressNameLabel.text = addressName
        self.latLabel.text = lat
        self.longLabel.text = long
    }
    
}
