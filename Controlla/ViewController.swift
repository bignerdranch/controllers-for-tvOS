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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.c = UISearchController(searchResultsController: self)
            if let c = self.c {
                let vc = UISearchContainerViewController(searchController: c)
                self.leftContainer.addSubview(vc.view)
                vc.view.frame = self.leftContainer.bounds
                self.addChildViewController(vc)
            }
        }
        startWatchingForControllers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopWatchingForControllers()
    }

    func startWatchingForControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.notify), name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.notify), name: .GCControllerDidDisconnect, object: nil)
        GCController.startWirelessControllerDiscovery(completionHandler: {})
    }
    
    func stopWatchingForControllers() {
        GCController.stopWirelessControllerDiscovery()
    }
    
    func notify(note: Notification) {
        if note.name == .GCControllerDidConnect {
            if let ctrl = note.object as? GCController {
                add(ctrl)
            }
        } else if note.name == .GCControllerDidDisconnect {
            if let ctrl = note.object as? GCController {
                remove(ctrl)
            }
        }
    }
    
    func add(_ controller: GCController) {
        controller.playerIndex = incrementPlayerIndex()
        var gamepadView : UIView?
        
        if let gamepad = controller.extendedGamepad {
            print("connect extended \(controller.vendorName)")
            gamepadView = ExtendedGamepadView(gamepad: gamepad)
        } else if let gamepad = controller.microGamepad {
            print("connect micro \(controller.vendorName)")
            gamepadView = MicroGamepadView(gamepad: gamepad)
        } else {
            print("Durp? \(controller.vendorName)")
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
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        var menuPressed = false
        for press in presses {
            if press.type == .menu {
                menuPressed = true
            }
        }
        if (menuPressed) {
            let alert = UIAlertController(title: "Quit?", message: "You sure you're out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yep, I'm out", style: .default, handler: { _ in
                self.controllerUserInteractionEnabled = true
                super.pressesBegan(presses, with: event)
                self.controllerUserInteractionEnabled = false
            }))
            alert.addAction(UIAlertAction(title: "Nevermind", style: .default, handler: { _ in }))
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

