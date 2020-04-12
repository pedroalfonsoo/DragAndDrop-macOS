//
//  FilePreviewView.swift
//  DragAndDrop
//
//  Created by Pedro Alfonso on 4/11/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Cocoa
import WebKit

class FilePreviewView: WKWebView {
    
    // App UI Element
    private let filePreviewInlineMessage: NSTextField = {
        let title = NSTextField()
        title.backgroundColor = .clear
        title.textColor = .white
        title.font = NSFont(name: "Helvetica", size: 28)
        title.stringValue = "File Preview"
        title.isBezeled = false
        title.isEditable = false
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
    
        return title
    }()
    
    // Properties
    private let unableToProcessMessage = "Unable to process, choose a text or web file"
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(filePreviewInlineMessage)
        
        filePreviewInlineMessage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        filePreviewInlineMessage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func loadBlankHTML() {
        guard let url = Bundle.main.url(forResource: "Blankhtml", withExtension: "html") else {
            return
        }
        
        load(URLRequest(url: url))
    }
    
    // Shows a descriptive message, when the preview can not be shown to the user
    //
    func showUnableToProcessMessage() {
        // Removes the content from the web view
        loadBlankHTML()
        
        filePreviewInlineMessage.stringValue = unableToProcessMessage
        filePreviewInlineMessage.isHidden = false
    }
    
    // Shows file's content using an URL, which is pointing the a local file
    //
    func loadFileWithURL(_ fileURL: URL) {
        loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        filePreviewInlineMessage.isHidden = true
    }
}
