//
//  CustomMarkerView.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/7/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
import UIKit

class CustomMarkerView: UIView {

    var markerType: MarkerType!
    var imgName: String!

    init(frame: CGRect, markerType type: MarkerType, imageName: String) {
        super.init(frame: frame)
        self.markerType = type
        self.imgName = imageName
        setupViews()
    }
    
    func setupViews() {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: imgName)
        imgView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        imgView.clipsToBounds = true
        self.addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
