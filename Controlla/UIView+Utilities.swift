//
//  UIView+Utilities.swift
//  Controlla
//
//  Created by Steve Sparks on 12/30/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

extension UIView {
    func makeSquare(_ size : CGFloat = -1) {
        let c = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
        addConstraint(c)
        if(size != -1) {
            addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size))
        }
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
    
    func pin(_ dimension : NSLayoutAttribute) {
        if let superview = superview {
            let c = NSLayoutConstraint(item: self, attribute: dimension, relatedBy: .equal, toItem: superview, attribute: dimension, multiplier: 1.0, constant: 0.0)
            superview.addConstraint(c)
        } else {
            NSLog("WAT")
        }
    }
}

