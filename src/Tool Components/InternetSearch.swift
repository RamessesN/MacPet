//
//  InternetSearch.swift
//  macPet
//
//  Created by 赵禹惟 on 2025/7/13.
//

import Cocoa

struct PetActions {
    static func InternetSearch() {
        guard let mainWindow = AppDelegate.mainWindow else { return }
        let petFrame = mainWindow.frame
        
        let windowSize = NSSize(width: 280, height: 100)
        let origin = NSPoint(
            x: petFrame.midX - windowSize.width/2,
            y: petFrame.maxY - 30
        )
        
        let inputWindow = NSWindow(contentRect: NSRect(origin: origin, size: windowSize),
                                   styleMask: [.titled],
                                   backing: .buffered,
                                   defer: false)
        
        inputWindow.title = "􀤆 Search"
        inputWindow.isReleasedWhenClosed = false
        inputWindow.level = .floating
        inputWindow.standardWindowButton(.closeButton)?.isHidden = false
        inputWindow.backgroundColor = NSColor.windowBackgroundColor
        inputWindow.isOpaque = false
        inputWindow.hasShadow = true
        inputWindow.titlebarAppearsTransparent = true
        inputWindow.styleMask.insert(.fullSizeContentView)
        inputWindow.isMovableByWindowBackground = true
        
        let contentView = NSView(frame: NSRect(origin: .zero, size: windowSize))
        inputWindow.contentView = contentView
        
        let inputField = NSTextField(frame: NSRect(x: 20, y: 40, width: windowSize.width - 40, height: 24))
        inputField.placeholderString = "Enter: "
        contentView.addSubview(inputField)
        
        let searchButton = NSButton(title: "Search", target: nil, action: nil)
        searchButton.frame = NSRect(x: windowSize.width - 100, y: 10, width: 80, height: 24)
        searchButton.bezelStyle = .rounded
        searchButton.setButtonType(.momentaryPushIn)
        searchButton.isBordered = false
        searchButton.wantsLayer = true
        searchButton.layer?.backgroundColor = NSColor.controlAccentColor.cgColor
        searchButton.layer?.cornerRadius = 6
        searchButton.contentTintColor = .white
        searchButton.keyEquivalent = "\r"
        contentView.addSubview(searchButton)
        
        let cancelButton = NSButton(title: "Cancel", target: nil, action: nil)
        cancelButton.frame = NSRect(x: 20, y: 10, width: 80, height: 24)
        cancelButton.bezelStyle = .rounded
        cancelButton.setButtonType(.momentaryPushIn)
        cancelButton.keyEquivalent = "\u{1b}"
        contentView.addSubview(cancelButton)
        
        searchButton.target = inputWindow
        searchButton.action = #selector(NSWindow.searchAction)
        
        cancelButton.target = inputWindow
        cancelButton.action = #selector(NSWindow.cancelAction)
        
        objc_setAssociatedObject(inputWindow, AssociatedKeys.inputFieldKey, inputField, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        objc_setAssociatedObject(inputWindow, AssociatedKeys.searchHandlerKey, {
            let query = inputField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if !query.isEmpty,
               let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: "https://www.bing.com/search?q=\(encoded)") {
                NSWorkspace.shared.open(url)
            }
        }, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        inputWindow.makeKeyAndOrderFront(nil)
        inputField.becomeFirstResponder()
    }
}

private struct AssociatedKeys {
    static let inputFieldKey = UnsafeRawPointer(Unmanaged.passUnretained(NSObject()).toOpaque())
    static let searchHandlerKey = UnsafeRawPointer(Unmanaged.passUnretained(NSObject()).toOpaque())
}

private extension NSWindow {
    @objc func searchAction() {
        if let handler = objc_getAssociatedObject(self, AssociatedKeys.searchHandlerKey) as? () -> Void {
            handler()
        }
        self.close()
    }
    @objc func cancelAction() {
        self.close()
    }
}
