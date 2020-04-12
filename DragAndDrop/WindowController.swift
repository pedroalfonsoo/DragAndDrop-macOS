//
//  WindowController.swift
//  DragAndDrop
//
//  Created by Pedro Alfonso on 4/10/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    override init(window: NSWindow?) {
        super.init(window: window)
    }
    
    convenience init(contentViewController_: NSViewController) {
        self.init()
        
        contentViewController = contentViewController_
        window = NSWindow(contentViewController: contentViewController_)
        
        setupWindow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWindow() {
        if let window_ = window, let screen = window_.screen {
            let screenRectangle = screen.visibleFrame
            
            // Window will cover 80% of the screen's width and height. Also, it will be positionated at the center of the screen
            window_.setFrame(CGRect(x: 0,
                                    y: 0,
                                    width: screenRectangle.width * 0.8,
                                    height: screenRectangle.height * 0.8), display: false)
            window_.center()
        }
    }
}
