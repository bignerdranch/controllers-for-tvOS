//
//  MicroGamepadView.swift
//  Controlla
//
//  Created by Steve Sparks on 12/29/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameKit

public class MicroGamepadView: UIStackView {

    public var gamepad : GCMicroGamepad? {
        didSet {
            assignGamepad()
        }
    }
    
    let aButtonView = SwitchIndicatorView.with("X", color: UIColor.yellow)
    let xButtonView = SwitchIndicatorView.with("A", color: UIColor.red)
    let dPadView = DirectionPadView()
    let motionView = MotionView()

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public convenience init(gamepad : GCMicroGamepad) {
        self.init(frame: .zero)
        self.gamepad = gamepad
        assignGamepad()
    }

    func setup() {
        self.axis = .horizontal
        self.spacing = 24.0
        
        let buttons = UIStackView(arrangedSubviews: [aButtonView, xButtonView])
        buttons.axis = .vertical
        buttons.spacing = 12.0
        buttons.makeSquare(200)
        buttons.addConstraint(NSLayoutConstraint(item: aButtonView, attribute: .height, relatedBy: .equal, toItem: xButtonView, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        dPadView.dotColor = UIColor.red
        dPadView.makeSquare(200)
        motionView.makeSquare(200)
        
        addArrangedSubview(buttons)
        addArrangedSubview(dPadView)
        addArrangedSubview(motionView)

    }
    
    func assignGamepad() {
        if let gamepad = gamepad {
            dPadView.pad = gamepad.dpad
            aButtonView.input = gamepad.buttonA
            xButtonView.input = gamepad.buttonX
            if let motion = gamepad.controller?.motion {
                motionView.motion = motion
                motionView.alpha = 1
            } else {
                motionView.motion = nil
                motionView.alpha = 0
            }
        } else {
            dPadView.pad = nil
            aButtonView.input = nil
            xButtonView.input = nil
            motionView.motion = nil
            motionView.alpha = 0
        }
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
}
