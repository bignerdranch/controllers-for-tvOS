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
    
    let aButtonView = ButtonIndicatorView.with("A", color: UIColor.green)
    let xButtonView = ButtonIndicatorView.with("X", color: UIColor.blue)
    let menuButtonView = ButtonIndicatorView.with("Menu", color: UIColor.yellow)
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
        self.alignment = .top
        self.spacing = 24.0
        
        let buttons = UIStackView(arrangedSubviews: [aButtonView, xButtonView])
        buttons.axis = .vertical
        buttons.spacing = 12.0
        buttons.makeSquare(200)
        buttons.addConstraint(NSLayoutConstraint(item: aButtonView, attribute: .height, relatedBy: .equal, toItem: xButtonView, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        menuButtonView.set(width:200, height:100)
        // MENU button gets pressed and released so fast on the siri-remote, slow down the color change
        menuButtonView.animateDuration = 1.5
        
        dPadView.dotColor = UIColor.red
        dPadView.makeSquare(200)
        motionView.makeSquare(200)
        
        addArrangedSubview(buttons)
        addArrangedSubview(menuButtonView)
        addArrangedSubview(dPadView)
        addArrangedSubview(motionView)
    }
    
    func assignGamepad() {
        if let gamepad = gamepad {
//            // method one
//            gamepad.valueChangedHandler = { (gamepad, element) in
//                if let dpad = element as? GCControllerDirectionPad {
//                    print("CTRL : \( dpad )")
//                } else {
//                    print("OTHR : \( element )")
//                }
//            }
//
//            // method two
//            gamepad.dpad.valueChangedHandler = { (dpad, xValue, yValue) in
//                print("DPAD : \( dpad )")
//            }
//
//            // method three
//            gamepad.dpad.xAxis.valueChangedHandler = { (axis, value) in
//                print("AXIS: \( axis ) -> \( value ) ")
//            }
//
//            if let ctrl = gamepad.controller {
//                ctrl.controllerPausedHandler = { controller in
//                    // play/pause here
//                    print("PLAY: \( controller ) ")
//                }
//            }

            dPadView.pad = gamepad.dpad
            aButtonView.input = gamepad.buttonA
            xButtonView.input = gamepad.buttonX
            
            if #available(tvOS 13.0, *) {
                menuButtonView.input = gamepad.buttonMenu
            } else {
                menuButtonView.removeFromSuperview()
            }
            
            motionView.removeFromSuperview()
            if let motion = gamepad.controller?.motion {
                addArrangedSubview(motionView)
                motionView.motion = motion
            }
        } else {
            dPadView.pad = nil
            aButtonView.input = nil
            xButtonView.input = nil
            motionView.motion = nil
        }
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
}
