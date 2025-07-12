//
//  TimeView.swift
//  macPet
//
//  Created by 赵禹惟 on 2025/7/13.
//

import SwiftUI

struct TimeView: View {
    @State private var currentTime = formattedTime(Date())

    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("􀐬 \(currentTime)")
        .font(.system(size: 14, weight: .medium))
        .foregroundColor(.white)
        .padding(6)
        .background(Color.gray.opacity(0.6))
        .cornerRadius(8)
        .onReceive(timer) { now in
            currentTime = Self.formattedTime(now)
        }
    }
}

extension TimeView {
    private static func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
