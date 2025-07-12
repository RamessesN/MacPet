//
//  PetImage.swift
//  macPet
//
//  Created by 赵禹惟 on 2025/7/13.
//

import SwiftUI

struct PetView: View {
    @State private var isNormal = true
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var moveTimer = Timer.publish(every: 8, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 8) {
            Group {
                if isNormal {
                    Image("Rem_face")
                        .resizable()
                        .scaledToFit()
                } else {
                    GIFImageView(gifName: "Ram&Rem")
                        .frame(width: 250, height: 250)
                }
            }
            .shadow(radius: 8)
            
            if isNormal {
                TimeView()
            }
        }
        .background(Color.clear)
        .contextMenu {
            Button("Search") {
                PetActions.InternetSearch()
            }
            Button("Quit") {
                NSApp.terminate(nil)
            }
        }
        .onReceive(timer) { _ in
            let normalTime = getUserTime()
            let newIsNormal = normalTime < 20
            
            if newIsNormal != isNormal {
                withAnimation(.easeIn) {
                    isNormal = newIsNormal
                }
            }
        }
        .onReceive(moveTimer) { _ in
            if !isNormal {
                RandomMove()
            }
        }
        .onChange(of: isNormal) { oldValue, newValue in
            if newValue == true && oldValue == false {
                returnOrigin()
            }
        }
    }
}

extension PetView {
    func RandomMove() {
        guard let window = AppDelegate.mainWindow,
              let screen = NSScreen.main else { return }

        let screenFrame = screen.visibleFrame
        let windowSize = window.frame.size

        let maxX = screenFrame.maxX - windowSize.width
        let maxY = screenFrame.maxY - windowSize.height

        let randomX = CGFloat.random(in: screenFrame.minX...maxX)
        let randomY = CGFloat.random(in: screenFrame.minY...maxY)
        let targetOrigin = CGPoint(x: randomX, y: randomY)
        let finalFrame = NSRect(origin: targetOrigin, size: windowSize)

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 5.0 // 移动时长
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().setFrame(finalFrame, display: true)
        }, completionHandler: nil)
    }
    
    func returnOrigin() {
        guard let window = AppDelegate.mainWindow,
              let origin = AppDelegate.startPosition else { return }
        
        let windowSize = window.frame.size
        let finalFrame = NSRect(origin: origin, size: windowSize)

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1.0
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().setFrame(finalFrame, display: true)
        })
    }
}
