//
//  GradientView.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/11/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.4823529412, green: 0.3843137255, blue: 0.7607843137, alpha: 1).cgColor,#colorLiteral(red: 0.3411764706, green: 0.7568627451, blue: 0.9529411765, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }

}


