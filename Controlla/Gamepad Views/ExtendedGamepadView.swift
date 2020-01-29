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
    let leftButtonView = ButtonIndicatorView.with("L1", color: UIColor.white)
    let rightButtonView = ButtonIndicatorView.with("R1", color: UIColor.white)
    let leftTriggerView = ButtonIndicatorView.with("L2", color: UIColor.yellow)
    let rightTriggerView = ButtonIndicatorView.with("R2", color: UIColor.yellow)

    let menuButtonView = ButtonIndicatorView.with("Menu", color: UIColor.yellow)
    let optionsButtonView = ButtonIndicatorView.with("Options", color: UIColor.yellow)

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
        assignGamepad()
    }
    
    func setup() {
        self.axis = .horizontal
        self.spacing = 24.0
        
        let leftButtons = UIStackView(arrangedSubviews: [ leftButtonView, leftTriggerView])
        let rightButtons = UIStackView(arrangedSubviews: [rightButtonView, rightTriggerView])
        let menuButtons = UIStackView(arrangedSubviews: [menuButtonView, optionsButtonView])

        leftButtons.spacing = 12.0
        rightButtons.spacing = 12.0
        menuButtons.spacing = 12.0

        leftButtons.addConstraint(NSLayoutConstraint(item: leftButtonView, attribute: .height, relatedBy: .equal, toItem: leftTriggerView, attribute: .height, multiplier: 1.0, constant: 0.0))
        rightButtons.addConstraint(NSLayoutConstraint(item: rightButtonView, attribute: .height, relatedBy: .equal, toItem: rightTriggerView, attribute: .height, multiplier: 1.0, constant: 0.0))
        menuButtons.addConstraint(NSLayoutConstraint(item: menuButtonView, attribute: .height, relatedBy: .equal, toItem: optionsButtonView, attribute: .height, multiplier: 1.0, constant: 0.0))

        leftButtons.makeSquare(200)
        leftButtons.axis = .vertical
        rightButtons.makeSquare(200)
        rightButtons.axis = .vertical
        menuButtons.makeSquare(200)
        menuButtons.axis = .vertical

        leftDpadView.dotColor = UIColor.red
        
        leftThumbstickView.makeSquare(200)
        leftThumbstickView.dotsize = 50
        leftThumbstickView.dotColor = .lightGray
        var l = leftThumbstickView.circleLayer
        l.shadowRadius = 20
        l.shadowColor = UIColor.black.cgColor
        l.shadowOpacity = 1
        l.shadowOffset = CGSize(width: 10, height: 10)
        
        rightThumbstickView.dotsize = 50
        rightThumbstickView.makeSquare(200)
        rightThumbstickView.dotColor = .lightGray
        l = rightThumbstickView.circleLayer
        l.shadowRadius = 20
        l.shadowColor = UIColor.black.cgColor
        l.shadowOpacity = 1
        l.shadowOffset = CGSize(width: 10, height: 10)
        
        leftDpadView.makeSquare(200)
        buttonPad.makeSquare(200)
        motionView.makeSquare(200)
        
        addArrangedSubview(leftButtons)
        addArrangedSubview(menuButtons)
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
            if #available(tvOS 13.0, *) {
                menuButtonView.input = gamepad.buttonMenu
                optionsButtonView.input = gamepad.buttonOptions
            }
            else {
                menuButtonView.superview?.removeFromSuperview()
            }
            leftDpadView.pad = gamepad.dpad
            
            motionView.removeFromSuperview()
            if let motion = gamepad.controller?.motion {
                addArrangedSubview(motionView)
                motionView.motion = motion
            }
            
            gamepad.leftThumbstickButton?.valueChangedHandler = {[weak self] button, value, pressed in
                self?.leftThumbstickView.dotColor = pressed ? .white : .lightGray
            }
            gamepad.rightThumbstickButton?.valueChangedHandler = {[weak self] button, value, pressed in
                self?.rightThumbstickView.dotColor = pressed ? .white : .lightGray
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
        }
        buttonPad.extendedGamepad = gamepad
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
}
