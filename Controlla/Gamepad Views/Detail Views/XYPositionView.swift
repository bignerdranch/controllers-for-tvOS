//
//  XYPositionView.swift
//  Controlla
//
//  Created by Steve Sparks on 12/29/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

@IBDesignable
public class XYPositionView: UIView {
    @IBInspectable public var dotColor : UIColor = .lightGray {
        didSet {
            circleLayer.fillColor = dotColor.cgColor
        }
    }
    @IBInspectable public var dotsize : CGFloat = 40.0 {
        didSet {
            var identity = CGAffineTransform.identity
            circleLayer.path = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: dotsize, height: dotsize), transform: &identity)
        }
    }
    
    // between -1 and 1
    public var x : CGFloat = 0 {
        didSet {
            updatePosition()
        }
    }
    public var y : CGFloat = 0 {
        didSet {
            updatePosition()
        }
    }

    func updatePosition() {
        let halfdot = CGFloat(dotsize / 2.0)
        
        let frm = self.bounds.size
        let multX = (x + 1.0)*0.5
        let newX = CGFloat(frm.width * multX) - halfdot
        let multY = y*0.5
        let newY = CGFloat(frm.height * multY) - halfdot

        circleLayer.frame = CGRect(x: newX, y: newY, width: dotsize, height: dotsize)
        circleLayer.fillColor = dotColor.cgColor
    }
        
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePosition()
    }
    
    lazy var circleLayer : CAShapeLayer = {
        let dotsize : CGFloat = 40.0

        let l = CAShapeLayer()
        var identity = CGAffineTransform.identity
        l.path = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: dotsize, height: dotsize), transform: &identity)
        l.speed = 10000
        self.layer.addSublayer(l)
        return l
    }()

}
