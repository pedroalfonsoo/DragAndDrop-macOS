//
//  AppDelegate.swift
//  DragAndDrop
//
//  Created by Pedro Alfonso on 4/10/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // The 'DragAndDropViewController' object, will be set on the 'WindowController'
        let mainWindowController = WindowController(contentViewController_: DragAndDropViewController())
        mainWindowController.showWindow(self)
    }
}

