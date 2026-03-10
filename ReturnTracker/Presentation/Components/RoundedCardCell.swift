//
//  RoundedCardCell.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 20.01.2026.
//

import Foundation
import SwiftUI

struct RoundedCardCell<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    RoundedCardCell {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.Preview.productTitle)
                .font(.headline)
            Text(L10n.Preview.productSubtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    .padding()
}
