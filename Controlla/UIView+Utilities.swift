//
//  UIView+Utilities.swift
//  Controlla
//
//  Created by Steve Sparks on 12/30/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

extension UIView {
    func set(width : CGFloat = -1, height : CGFloat = -1) {
        if(width != -1) {
            addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width))
        }
        if(height != -1) {
            addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        }
    }
    
    func makeSquare(_ width : CGFloat = -1) {
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier:1.0, constant: 0.0))
        set(width:width)
    }

    func centerHorizontally() {
        if let superview = superview {
            let c = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            superview.addConstraint(c)
        } else {
            NSLog("WAT")
        }
    }
    
    func centerVertically() {
        if let superview = superview {
            let c = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            superview.addConstraint(c)
        } else {
            NSLog("WAT")
        }
    }
    
    func pin(_ dimension : NSLayoutConstraint.Attribute) {
        if let superview = superview {
            let c = NSLayoutConstraint(item: self, attribute: dimension, relatedBy: .equal, toItem: superview, attribute: dimension, multiplier: 1.0, constant: 0.0)
            superview.addConstraint(c)
        } else {
            NSLog("WAT")
        }
    }
}

