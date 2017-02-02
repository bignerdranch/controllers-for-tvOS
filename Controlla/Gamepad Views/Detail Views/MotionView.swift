//
//  MotionView.swift
//  Controlla
//
//  Created by Steve Sparks on 12/29/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameKit

public enum MotionViewType {
    
    case gravity
    case userAcceleration
}

@IBDesignable
public class MotionView: XYPositionView {
    var type : MotionViewType = .gravity
    var motion : GCMotion? {
        willSet {
            if let m = newValue {
                m.valueChangedHandler = { _ in
                        self.updateMotion()
                }
            } else {
                motion?.valueChangedHandler = nil
            }
        }
    }

    func updateMotion() {
        if let motion = motion {
            let acc = (type == .gravity ? motion.gravity : motion.userAcceleration)
            x = CGFloat((acc.x))
            y = CGFloat((acc.y)+1)
            dotsize = CGFloat((acc.z*10)+20)
        }
    }
 
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0.4, alpha: 1.0)
        let l = self.layer
        l.cornerRadius = 20
        
        x = 0
        y = 0
    }
    
    // MARK: IBDesignable support
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
}
