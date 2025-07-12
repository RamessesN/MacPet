//
//  AppDelegate.swift
//  macPet
//
//  Created by 赵禹惟 on 2025/7/10.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    static var mainWindow: NSWindow?
    static var startPosition: CGPoint?

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            Self.mainWindow = window
            
            window.level = .floating
            window.isOpaque = false
            window.backgroundColor = .clear
            window.hasShadow = false
            window.isMovableByWindowBackground = true
            window.collectionBehavior = [.canJoinAllSpaces, .stationary]
            window.styleMask.remove(.resizable)
            window.styleMask = [.borderless]
            
            if let screen = NSScreen.main {
                let screenRect = screen.visibleFrame
                let windowSize = NSSize(width: 300, height: 300)
                
                let origin = CGPoint(
                    x: screenRect.maxX - windowSize.width - 20,
                    y: screenRect.minY + 20
                )
                Self.startPosition = origin

                let windowFrame = NSRect(origin: origin, size: windowSize)
                window.setFrame(windowFrame, display: true)
            }
            
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
