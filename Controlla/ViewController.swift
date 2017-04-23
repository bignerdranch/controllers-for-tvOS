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

class ViewController: GCEventViewController, UISearchResultsUpdating {
    @IBOutlet weak var controllerStack: UIStackView!
    @IBOutlet weak var leftContainer: UIView!
    
    var gamepadMap : [NSObject : UIView] = [:]
    var c : UISearchController?

    public func updateSearchResults(for searchController: UISearchController) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startWatchingForControllers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopWatchingForControllers()
    }

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
    
    var playerIndex = GCControllerPlayerIndex.index1
    
    func incrementPlayerIndex() -> GCControllerPlayerIndex {
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
        let ctr = NotificationCenter.default
        ctr.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) { note in
            if let ctrl = note.object as? GCController {
                self.add(ctrl)
            }
        }
        ctr.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: .main) { note in
            if let ctrl = note.object as? GCController {
                self.remove(ctrl)
            }
        }
        GCController.startWirelessControllerDiscovery(completionHandler: {})
    }

    func stopWatchingForControllers() {
        let ctr = NotificationCenter.default
        ctr.removeObserver(self, name: .GCControllerDidConnect, object: nil)
        ctr.removeObserver(self, name: .GCControllerDidDisconnect, object: nil)
        GCController.stopWirelessControllerDiscovery()
    }


    func add(_ controller: GCController) {
        controller.playerIndex = incrementPlayerIndex()
        var gamepadView : UIView?

        let name = String(describing:controller.vendorName)
        if let gamepad = controller.extendedGamepad {
            print("connect extended \(name)")
            gamepadView = ExtendedGamepadView(gamepad: gamepad)
        } else if let gamepad = controller.microGamepad {
            print("connect micro \(name)")
            gamepadView = MicroGamepadView(gamepad: gamepad)
        } else {
            print("Huh? \(name)")
        }

        if let gamepadView = gamepadView {
            gamepadMap[controller] = gamepadView
            controllerStack.addArrangedSubview(gamepadView)
        }
    }

    func remove(_ controller: GCController) {
        if let view = gamepadMap[controller] {
            print("disconnect")
            view.removeFromSuperview()
            gamepadMap[controller] = nil
        }
    }
}
