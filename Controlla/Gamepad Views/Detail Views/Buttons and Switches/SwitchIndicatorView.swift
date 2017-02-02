//
//  SwitchIndicatorView.swift
//  Controlla
//
//  Created by Steve Sparks on 12/29/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameKit

@IBDesignable
class SwitchIndicatorView: UILabel {
    public var input : GCControllerButtonInput? {
        willSet {
            if newValue == nil {
                input?.valueChangedHandler = nil
            } else {
                newValue?.valueChangedHandler = { _ in
                    self.fixColor()
                }
            }
        }
    }
    
    @IBInspectable public var color : UIColor = .red {
        didSet {
            fixColor()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.fixColor()
        self.roundMe()
    }
    
    func fixColor() {
        self.textAlignment = .center

        // set my color
        var c = color
        if let input = input {
            if (input.isPressed) {
                let comp = color.components
                c = UIColor(red: comp.red/2.0, green: comp.green/2.0, blue: comp.blue/2.0, alpha: 1.0)
            }
        }
        self.layer.backgroundColor = c.cgColor

    }
    
    func roundMe() {
        let size = self.frame.size
        let shortside = fmax(fmin(fmin(size.width, size.height), 80), 10)
        self.layer.cornerRadius = shortside / 2.0
    }
    
    static func with(_ label: String, color: UIColor) -> SwitchIndicatorView {
        let v = SwitchIndicatorView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = label
        v.textColor = color
        v.color = UIColor.darkGray
        return v
    }
    
    // MARK: IBDesignable support
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        fixColor()
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}
