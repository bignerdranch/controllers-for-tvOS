//
//  ContentProvider.swift
//  TopShelf
//
//  Created by Todd Laney on 1/2/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import TVServices
import GameController

class ContentProvider: TVTopShelfContentProvider {
    
    enum Image {
        static let siri = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Apple_tv_gen_4_remote.jpeg/2560px-Apple_tv_gen_4_remote.jpeg"
        //static let siri = "https://developer.apple.com/design/human-interface-guidelines/tvos/images/remote-and-interaction-remote_2x.png"
        static let xbox = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Microsoft-Xbox-One-controller.jpg/1920px-Microsoft-Xbox-One-controller.jpg"
        static let ps4 = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/DualShock_4.jpg/1920px-DualShock_4.jpg"
        static let mfi  = "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/HJ162?wid=1144&hei=1144&fmt=jpeg&qlt=95&op_usm=0.5%2C0.5&.v=1477094888716"
        static let atari = "https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Atari-2600-Joystick.jpg/1920px-Atari-2600-Joystick.jpg"
    }
    
    override func loadTopShelfContent(completionHandler: @escaping (TVTopShelfContent?) -> Void) {
        
        var items = GCController.controllers().map() {controller -> TVTopShelfSectionedItem in
            let name = "\(controller.vendorName ?? "") (\(controller.productCategory))"

            let item = TVTopShelfSectionedItem(identifier:UUID().uuidString)
            item.title = name
            
            var url = Image.atari
            item.imageShape = .square

            if name.contains("Xbox") {url = Image.xbox}
            if name.contains("DualShock") {url = Image.ps4}
            if name.contains("Siri") {url = Image.siri}
            if name.contains("MFi") {url = Image.mfi}

            item.setImageURL(URL(string:url)!, for:.screenScale1x)

            return item
        }
        
        // you would think GCController.controllers() would always have at least the Siri Remote, but sometimes it is empty
        if items.isEmpty {
            items += [Image.atari, Image.mfi, Image.xbox, Image.ps4, Image.siri].map() {url -> TVTopShelfSectionedItem in
                let item = TVTopShelfSectionedItem(identifier:url)
                item.title = "Sample"
                item.imageShape = .square
                item.setImageURL(URL(string:url)!, for:.screenScale1x)
                return item
            }
        }
        
        if items.isEmpty {
            return completionHandler(nil);
        }

        let section = TVTopShelfItemCollection(items:items)
        section.title = "Controllers"
        let content = TVTopShelfSectionedContent(sections:[section])
        completionHandler(content);
    }

}

