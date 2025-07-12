//
//  DesktopPet.swift
//  macPet
//
//  Created by 赵禹惟 on 2025/7/13.
//

import SwiftUI

@main
struct DesktopPet: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            PetView()
                .frame(width: 300, height: 300)
                .background(Color.clear)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
