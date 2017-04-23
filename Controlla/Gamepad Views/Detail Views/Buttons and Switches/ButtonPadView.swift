//
//  ButtonPadView.swift
//  Controlla
//
//  Created by Steve Sparks on 12/29/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameKit

// For ABXY controllers
@IBDesignable
public class ButtonPadView: UIView {

    let aButtonView = ButtonIndicatorView.with("A", color: UIColor.red)
    let bButtonView = ButtonIndicatorView.with("B", color: UIColor.green)
    let xButtonView = ButtonIndicatorView.with("X", color: UIColor.yellow)
    let yButtonView = ButtonIndicatorView.with("Y", color: UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0))
    
    var extendedGamepad : GCExtendedGamepad? {
        willSet {
            if let pad = newValue {
                aButtonView.input = pad.buttonA
                bButtonView.input = pad.buttonB
                xButtonView.input = pad.buttonX
                yButtonView.input = pad.buttonY
            } else {
                aButtonView.input = nil
                bButtonView.input = nil
                xButtonView.input = nil
                yButtonView.input = nil
            }
        }
    }
    
    var gamepad : GCGamepad? {
        willSet {
            if let pad = newValue {
                aButtonView.input = pad.buttonA
                bButtonView.input = pad.buttonB
                xButtonView.input = pad.buttonX
                yButtonView.input = pad.buttonY
            } else {
                aButtonView.input = nil
                bButtonView.input = nil
                xButtonView.input = nil
                yButtonView.input = nil
            }
        }
    }
    
    func setup() {
        addSubview(aButtonView)
        addSubview(bButtonView)
        addSubview(xButtonView)
        addSubview(yButtonView)
        
        let buttonSize : CGFloat = 70.0
        
        aButtonView.makeSquare(buttonSize)
        aButtonView.pin(.bottom)
        aButtonView.centerHorizontally()
        
        bButtonView.makeSquare(buttonSize)
        bButtonView.pin(.right)
        bButtonView.centerVertically()
        
        xButtonView.makeSquare(buttonSize)
        xButtonView.pin(.left)
        xButtonView.centerVertically()

        yButtonView.makeSquare(buttonSize)
        yButtonView.pin(.top)
        yButtonView.centerHorizontally()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        NSLog(" \(String(describing:aButtonView.frame)) in \(String(describing:aButtonView.superview))")
    }

    override public func willMove(toSuperview superview: UIView?) {
        super.willMove(toSuperview: superview)
        if(aButtonView.superview == nil) {
            setup()
        }
    }
    
    // MARK: IBDesignable support
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
}

