//
//  ExtendedGamepadView.swift
//  Controlla
//
//  Created by Steve Sparks on 12/28/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameKit

@IBDesignable
public class ExtendedGamepadView: UIStackView {
    public var gamepad : GCExtendedGamepad? {
        didSet {
            assignGamepad()
        }
    }    

    let identifierLabel = UILabel()
    let leftButtonView = ButtonIndicatorView.with("Left", color: UIColor.white)
    let rightButtonView = ButtonIndicatorView.with("Right", color: UIColor.white)
    let leftTriggerView = ButtonIndicatorView.with("Left", color: UIColor.yellow)
    let rightTriggerView = ButtonIndicatorView.with("Right", color: UIColor.yellow)
    
    let leftThumbstickView = DirectionPadView()
    let leftDpadView = DirectionPadView()
    let rightThumbstickView = DirectionPadView()
    let buttonPad = ButtonPadView()
    let motionView = MotionView()
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public convenience init(gamepad: GCExtendedGamepad) {
        self.init(frame: .zero)
        self.gamepad = gamepad
        setup()
        assignGamepad()
    }
    
    func setup() {
        self.axis = .horizontal
        self.spacing = 24.0
        
        let leftButtons = UIStackView(arrangedSubviews: [ leftButtonView, leftTriggerView])
        let rightButtons = UIStackView(arrangedSubviews: [rightButtonView, rightTriggerView])
        
        leftButtons.spacing = 12.0
        rightButtons.spacing = 12.0
        
        leftButtons.addConstraint(NSLayoutConstraint(item: leftButtonView, attribute: .height, relatedBy: .equal, toItem: leftTriggerView, attribute: .height, multiplier: 1.0, constant: 0.0))
        rightButtons.addConstraint(NSLayoutConstraint(item: rightButtonView, attribute: .height, relatedBy: .equal, toItem: rightTriggerView, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        
        leftButtons.makeSquare(200)
        leftButtons.axis = .vertical
        rightButtons.makeSquare(200)
        rightButtons.axis = .vertical
        
        leftDpadView.dotColor = UIColor.red
        
        leftThumbstickView.makeSquare(200)
        leftThumbstickView.dotsize = 50
        var l = leftThumbstickView.circleLayer
        l.shadowRadius = 20
        l.shadowColor = UIColor.black.cgColor
        l.shadowOpacity = 1
        l.shadowOffset = CGSize(width: 10, height: 10)
        
        rightThumbstickView.dotsize = 50
        rightThumbstickView.makeSquare(200)
        l = rightThumbstickView.circleLayer
        l.shadowRadius = 20
        l.shadowColor = UIColor.black.cgColor
        l.shadowOpacity = 1
        l.shadowOffset = CGSize(width: 10, height: 10)
        
        leftDpadView.makeSquare(200)
        buttonPad.makeSquare(200)
        motionView.makeSquare(200)
        
        addArrangedSubview(leftButtons)
        addArrangedSubview(leftDpadView)
        addArrangedSubview(leftThumbstickView)
        addArrangedSubview(rightThumbstickView)
        addArrangedSubview(buttonPad)
        addArrangedSubview(rightButtons)
        addArrangedSubview(motionView)
    }

    func assignGamepad() {
        if let gamepad = gamepad {
            leftThumbstickView.pad = gamepad.leftThumbstick
            rightThumbstickView.pad = gamepad.rightThumbstick
            leftButtonView.input = gamepad.leftShoulder
            leftTriggerView.input = gamepad.leftTrigger
            rightButtonView.input = gamepad.rightShoulder
            rightTriggerView.input = gamepad.rightTrigger
            leftDpadView.pad = gamepad.dpad
            if let motion = gamepad.controller?.motion {
                motionView.motion = motion
                motionView.alpha = 1
            } else {
                motionView.alpha = 0
            }
        } else {
            leftThumbstickView.pad = nil
            rightThumbstickView.pad = nil
            leftButtonView.input = nil
            leftTriggerView.input = nil
            rightButtonView.input = nil
            rightTriggerView.input = nil
            leftDpadView.pad = nil
            motionView.motion = nil
            motionView.alpha = 0
        }
        buttonPad.extendedGamepad = gamepad
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
}
