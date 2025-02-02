//
//  SemiCircleView.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/24/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class SemiCircleView: UIView {

    var semiCirleLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()
        if semiCirleLayer == nil {
            let arcCenter = CGPoint(x: bounds.size.width / 2, y: -70)
            let circleRadius = (bounds.size.width) / 1.2
            let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: -CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true)
            semiCirleLayer = CAShapeLayer()
            semiCirleLayer.path = circlePath.cgPath
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [#colorLiteral(red: 0.3411764706, green: 0.7568627451, blue: 0.9529411765, alpha: 1).cgColor,#colorLiteral(red: 0.4823529412, green: 0.3843137255, blue: 0.7607843137, alpha: 1).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.frame = self.frame
            gradientLayer.mask = semiCirleLayer
            self.layer.mask = semiCirleLayer
            self.layer.addSublayer(gradientLayer)
            backgroundColor = UIColor.lightText
        }
        self.frame.origin.y = -10
    }


}



