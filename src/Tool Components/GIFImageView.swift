//
//  GIFImageView.swift
//  macPet
//
//  Created by 赵禹惟 on 2025/7/13.
//

import SwiftUI
import AppKit

struct GIFImageView: NSViewRepresentable {
    let gifName: String

    func makeNSView(context: Context) -> NSImageView {
        let imageView = NSImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.canDrawSubviewsIntoLayer = true
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.animates = true
        imageView.wantsLayer = true

        if let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
           let data = NSData(contentsOfFile: path),
           let image = NSImage(data: data as Data) {
            imageView.image = image
        }

        return imageView
    }

    func updateNSView(_ nsView: NSImageView, context: Context) {
    }

    static func dismantleNSView(_ nsView: NSImageView, coordinator: ()) {
        nsView.image = nil
    }

    func sizeThatFits(_ proposal: ProposedViewSize, nsView: NSImageView, context: Context) -> CGSize? {
        return proposal.replacingUnspecifiedDimensions()
    }
}
