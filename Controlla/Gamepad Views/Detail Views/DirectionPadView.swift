//
//  DirectionPadView.swift
//  Controlla
//
//  Created by Steve Sparks on 12/29/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameKit

@IBDesignable
public class DirectionPadView: XYPositionView {
    var pad : GCControllerDirectionPad? {
        willSet {
            if let pad = newValue {
                pad.xAxis.valueChangedHandler = { _ in
                    self.readPad()
                }
                pad.yAxis.valueChangedHandler = { _ in
                    self.readPad()
                }
            } else {
                pad?.xAxis.valueChangedHandler = nil
                pad?.yAxis.valueChangedHandler = nil
            }
        }
        
        didSet {
            readPad()
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
        self.backgroundColor = UIColor.darkGray
        let l = self.layer
        
        l.cornerRadius = 20
        
        x = 0
        y = 0
    }
    
    func readPad() {
        if let pad = pad {
            x = CGFloat(pad.xAxis.value)
            y = CGFloat(1 - pad.yAxis.value)
        }
    }
    
    // MARK: IBDesignable support
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
}
