//
//  DragAndDropViewController.swift
//  DragAndDrop
//
//  Created by Pedro Alfonso on 4/10/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Cocoa

class DragAndDropViewController: NSViewController, NSWindowDelegate {
    
    // StackView object, will contain the "Drop view" and the "File preview view"
    private let verticalStackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.alignment = .left
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Properties
    private let dropView: DropView
    private let filePreviewView: FilePreviewView
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        dropView = DropView()
        filePreviewView = FilePreviewView()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView()
    }
    
    override func viewWillAppear() {
        // This will let the current view controller to handle NSWindow callbacks
        view.window?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // Stops the window from being dismissed. The window will be shown again if the user clicks on the app icon
    //
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApp.hide(nil)
        return false
    }
    
    private func setupVerticalStackView() {
        let topBottomMargin: CGFloat = 20
        let leadingAndTrailingMargin: CGFloat = 80
               
        verticalStackView.addArrangedSubview(dropView)
        verticalStackView.addArrangedSubview(filePreviewView)
        
        verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingAndTrailingMargin).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingAndTrailingMargin).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: topBottomMargin).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -topBottomMargin).isActive = true
    }
    
    private func setupView() {
        title = "Drag & Drop Utility"
        dropView.delegate = self
        
        view.addSubview(verticalStackView)
        setupVerticalStackView()
    }
}

extension DragAndDropViewController: DropViewDelegate {
    func dropOperationDidSucceed(fileURL: URL) {
        filePreviewView.loadFileWithURL(fileURL)
    }
    
    func dropOperationDidFail() {
        filePreviewView.showUnableToProcessMessage()
    }
}

