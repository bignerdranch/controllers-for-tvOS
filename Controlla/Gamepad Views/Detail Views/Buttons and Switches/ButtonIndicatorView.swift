//
//  ButtonIndicatorView.swift
//  Controlla
//
//  Created by Steve Sparks on 12/29/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameKit

@IBDesignable
class ButtonIndicatorView: UILabel {
    public var animateDuration = 0.0    // default to no animation
    
    public var input : GCControllerButtonInput? {
        willSet {
            // clear the old handler
            if let control = input {
                control.valueChangedHandler = nil
            }
            if let control = newValue {
                self.alpha = 1
                control.pressedChangedHandler = {[weak self] _, _, _ in
                    self?.fixColor()
                }
            }
            else {
                self.alpha = 0
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
            c = color * (0.25 + (1.0 - input.value) * 0.75)
        } else {
            c = .black
        }
        UIView.animate(withDuration: self.animateDuration) {
            self.layer.backgroundColor = c.cgColor
        }
    }
    
    func roundMe() {
        let size = self.frame.size
        let shortside = fmax(fmin(fmin(size.width, size.height), 80), 10)
        self.layer.cornerRadius = shortside / 2.0
    }
    
    static func with(_ label: String, color: UIColor) -> ButtonIndicatorView {
        let v = ButtonIndicatorView()
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
    static func * (color: UIColor, value: CGFloat)-> UIColor {
        let c = color.components
        return UIColor(red: c.red * value, green: c.green * value, blue: c.blue * value, alpha: c.alpha)
    }
    static func * (color: UIColor, value: Float)-> UIColor {
        return color * CGFloat(value)
    }
    static func / (color: UIColor, value: Float)-> UIColor {
        return color * CGFloat(1.0 / value)
    }
}

