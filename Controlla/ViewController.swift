//
//  ViewController.swift
//  Controlla
//
//  Created by Steve Sparks on 12/28/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameKit
import GamepadViews

class ViewController: GCEventViewController {
    @IBOutlet weak var controllerStack: UIStackView!
    
    var gamepadMap : [GCController : UIView] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startWatchingForControllers()
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopWatchingForControllers()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    /* we dont need to do things like this, you can just use the menuButton handler
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        var menuPressed = false
        for press in presses {
            if press.type == .menu {
                menuPressed = true
            }
        }
        if (menuPressed) {
            self.controllerUserInteractionEnabled = true
            let alert = UIAlertController(title: "Quit?", message: "You sure you're out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yep, I'm out", style: .default) { _ in
                super.pressesBegan(presses, with: event)
            })
            alert.addAction(UIAlertAction(title: "Nevermind", style: .default) { _ in
                self.controllerUserInteractionEnabled = false
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    */
    
    var playerIndex = GCControllerPlayerIndex.indexUnset
    
    func nextPlayerIndex() -> GCControllerPlayerIndex {
        switch playerIndex {
        case .index1:
            playerIndex = .index2
        case .index2:
            playerIndex = .index3
        case .index3:
            playerIndex = .index4
        default:
            playerIndex = .index1
        }
        return playerIndex
    }
}

extension ViewController { // controller detection
    func startWatchingForControllers() {
        NotificationCenter.default.addObserver(self, selector:#selector(controllerDidConnect(note:)), name:.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(controllerDidConnect(note:)), name:.GCControllerDidDisconnect, object: nil)
        if GCController.controllers().count == 0 {
            GCController.startWirelessControllerDiscovery()
        } else {
            self.updateControllers()
        }
    }

    func stopWatchingForControllers() {
        NotificationCenter.default.removeObserver(self, name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.removeObserver(self, name: .GCControllerDidDisconnect, object: nil)
        GCController.stopWirelessControllerDiscovery()
    }
    
    @objc func controllerDidConnect(note:NSNotification) {
        guard let controller = note.object as? GCController else {return}
        if gamepadMap[controller] == nil {
            self.updateControllers()
        }
    }
    @objc func controllerDidDisconnect(note:NSNotification) {
        guard let _ = note.object as? GCController else {return}
        self.updateControllers()
    }

    //
    func updateControllers() {
        
        // remove all our current controllers, and make a whole new list
        for controller in Array(gamepadMap.keys) {
            self.remove(controller)
        }
        
        // build a brand new list of controllers, and give priority to exetended (ie non siri-remote) ones first.
        self.playerIndex = .indexUnset
        for controller in GCController.controllers().filter({$0.extendedGamepad != nil}) {
            self.add(controller)
        }
        for controller in GCController.controllers().filter({$0.extendedGamepad == nil}) {
            self.add(controller)
        }
    }

    func add(_ controller: GCController) {
        var gamepadView : UIView?

        var name = controller.vendorName ?? "Unknown Vendor"
        
        if #available(tvOS 13.0, *) {
            name += " (\(controller.productCategory))"
        }

        if let gamepad = controller.extendedGamepad {
            print("connect extended \(name)")
            gamepadView = ExtendedGamepadView(gamepad: gamepad)
        } else if let gamepad = controller.microGamepad {
            print("connect micro \(name)")
            gamepad.allowsRotation = true
            gamepad.reportsAbsoluteDpadValues = false
            gamepadView = MicroGamepadView(gamepad: gamepad)
        } else {
            print("Huh? \(name)")
        }

        if let gamepadView = gamepadView {
            controller.playerIndex = nextPlayerIndex()

            let text = "Player \(controller.playerIndex.rawValue+1): \(name)"
            let titleView = UILabel(text:text, color:.white, font:UIFont.preferredFont(forTextStyle:.headline))
            let view = UIStackView(arrangedSubviews:[titleView, gamepadView])
            view.axis = .vertical
            view.alignment = .center
            view.distribution = .equalSpacing
            view.spacing = 4.0
            
            gamepadMap[controller] = view
            controllerStack.addArrangedSubview(view)
        }
    }

    func remove(_ controller: GCController) {
        if let view = gamepadMap[controller] {
            print("disconnect: \(controller.vendorName ?? "")")
            view.removeFromSuperview()
            gamepadMap[controller] = nil
        }
    }
}

private extension UILabel {
    convenience init(text:String, color:UIColor? = nil, background:UIColor? = .clear, font:UIFont? = nil, align:NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.textColor = color
        self.backgroundColor = background
        self.textAlignment = align
        self.font = font
    }
}
