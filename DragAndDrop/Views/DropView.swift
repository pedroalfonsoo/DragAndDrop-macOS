//
//  DragView.swift
//  DragAndDrop
//
//  Created by Pedro Alfonso on 4/10/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Cocoa

protocol DropViewDelegate: class {
    func dropOperationDidSucceed(fileURL: URL)
    func dropOperationDidFail()
}

class DropView: NSView {
    private enum FileExtensionTypes: String {
        case html
        case txt
        case none
        
        func getImage() -> NSImage? {
            var imageName = "green_down_icon"
            
            switch self {
            case .html:
                imageName = "html_icon"
            case .txt:
                imageName = "txt_icon"
            case .none:
                imageName = "green_down_icon"
            }
            
            guard let image = NSImage(named: imageName) else {
                return nil
            }
            
            return image
        }
    }
    
    // App UI Elements
    private let verticalStackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
          
        return stackView
    }()
    
    private let dropViewFileExtensionImage: NSImageView = {
        let image = NSImageView()
        image.image = NSImage(named: "green_down_icon")
       
        return image
    }()
    
    private let dropViewInlineMessage: NSTextField = {
        let title = NSTextField()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = NSFont(name: "Helvetica", size: 28)
        title.stringValue = defaultDropViewTitle
        title.isBezeled = false
        title.isEditable = false
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
    
        return title
    }()
    
    // Properties
    private var fileURL: URL
    private var selectedFileExtension: FileExtensionTypes
    private var fileExtensionIsAllowed = false
    private var wasDropAbandoned = false
    private static let defaultDropViewTitle = "Drop file here (.html, .txt)"
    weak var delegate: DropViewDelegate?
    
    override init(frame frameRect: NSRect) {
        fileURL = URL(fileURLWithPath: "")
        selectedFileExtension = .none
        
        super.init(frame: .zero)
        registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue:"NSFilenamesPboardType")])
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
            
        verticalStackView.addArrangedSubview(dropViewFileExtensionImage)
        verticalStackView.addArrangedSubview(dropViewInlineMessage)
        addSubview(verticalStackView)
        
        verticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        verticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // Updates the file extension image and the in line message, after a drag was performed
    //
    private func updateViewAfterDragEvent() {
        dropViewFileExtensionImage.image = selectedFileExtension.getImage()
        dropViewInlineMessage.stringValue = fileExtensionIsAllowed ?
            fileURL.lastPathComponent : DropView.defaultDropViewTitle
    }
}


// MARK: NSDraggingDestinatio Delegates

extension DropView {
    
    // Gets the selected file information (url and file extension) and sets properties
    //
    private func getAndSetFileInfo(drag: NSDraggingInfo) {
        if let board = drag.draggingPasteboard.propertyList(forType:
                   NSPasteboard.PasteboardType(rawValue:"NSFilenamesPboardType")) as? [String],
                   let fileURL_ = board.first {
            fileURL = URL(fileURLWithPath: fileURL_)
            selectedFileExtension = FileExtensionTypes(rawValue: fileURL.pathExtension.lowercased()) ?? FileExtensionTypes.none
        }
    }
    
    private func isFileExtensionAllowed(drag: NSDraggingInfo) -> Bool {
        return selectedFileExtension != FileExtensionTypes.none
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        wasDropAbandoned = false
        getAndSetFileInfo(drag: sender)
        fileExtensionIsAllowed = isFileExtensionAllowed(drag: sender)
        
        return fileExtensionIsAllowed ? [.copy] : [.delete]
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        wasDropAbandoned = true
    }
    
    // When the dragging event ends, if the extension is not allowed, then the view will be updated
    //
    override func draggingEnded(_ sender: NSDraggingInfo) {
        if !fileExtensionIsAllowed && !wasDropAbandoned {
            updateViewAfterDragEvent()
            delegate?.dropOperationDidFail()
        }
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        updateViewAfterDragEvent()
        
        if fileExtensionIsAllowed {
            delegate?.dropOperationDidSucceed(fileURL: fileURL)
        }
        
        return true
    }
}
