//
//  GamepadView.swift
//  Controlla
//
//  Created by Steve Sparks on 12/30/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameKit

public class GamepadView: UIStackView {
    public var gamepad : GCGamepad? {
        didSet {
            assignGamepad()
        }
    }
    
    let identifierLabel = UILabel()
    let leftButtonView = SwitchIndicatorView.with("Left", color: UIColor.white)
    let rightButtonView = SwitchIndicatorView.with("Right", color: UIColor.white)
    
    let dpadView = DirectionPadView()
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
    
    func setup() {
        self.axis = .horizontal
        self.spacing = 24.0
        
        dpadView.dotColor = UIColor.red
        
        buttonPad.makeSquare(200)
        motionView.makeSquare(200)
        
        addArrangedSubview(leftButtonView)
        addArrangedSubview(dpadView)
        addArrangedSubview(buttonPad)
        addArrangedSubview(rightButtonView)
        addArrangedSubview(motionView)
    }
    
    func assignGamepad() {
        if let gamepad = gamepad {
            leftButtonView.input = gamepad.leftShoulder
            rightButtonView.input = gamepad.rightShoulder
            dpadView.pad = gamepad.dpad
            if let motion = gamepad.controller?.motion {
                motionView.motion = motion
                motionView.alpha = 1
            } else {
                motionView.alpha = 0
            }
        } else {
            leftButtonView.input = nil
            rightButtonView.input = nil
            dpadView.pad = nil
            motionView.motion = nil
            motionView.alpha = 0
        }
        buttonPad.gamepad = gamepad
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
}
