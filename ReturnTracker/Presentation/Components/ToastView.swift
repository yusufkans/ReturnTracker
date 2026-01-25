//
//  ToastView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 06.02.2026.
//

import SwiftUI

struct ToastState: Identifiable, Equatable {
    let id = UUID()
    let message: String
}

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 2)
            )
            .accessibilityLabel(message)
    }
}
