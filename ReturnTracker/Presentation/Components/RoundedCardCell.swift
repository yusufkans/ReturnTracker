//
//  RoundedCardCell.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 20.01.2026.
//

import Foundation
import SwiftUI
import UIKit

struct RoundedCardCell<Content: View>: View {
    struct SwipeActionConfiguration {
        let title: String
        let symbolName: String
        let tint: Color
        let isEnabled: Bool
        let onTrigger: () -> Void

        init(
            title: String,
            symbolName: String = "checkmark.circle.fill",
            tint: Color = .green,
            isEnabled: Bool = true,
            onTrigger: @escaping () -> Void
        ) {
            self.title = title
            self.symbolName = symbolName
            self.tint = tint
            self.isEnabled = isEnabled
            self.onTrigger = onTrigger
        }
    }

    private enum SwipeMetrics {
        static let maxOffset: CGFloat = 220
        static let triggerOffset: CGFloat = 165
    }

    private let content: Content
    private let swipeAction: SwipeActionConfiguration?
    @State private var horizontalOffset: CGFloat = 0

    init(
        swipeAction: SwipeActionConfiguration? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.swipeAction = swipeAction
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .leading) {
            if let swipeAction {
                swipeBackground(for: swipeAction)
            }

            cardSurface
                .offset(x: horizontalOffset)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.82), value: horizontalOffset)
        .applyIf(swipeAction != nil) { view in
            view.gesture(swipeGesture)
        }
    }

    private var cardSurface: some View {
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

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onChanged { value in
                guard let swipeAction, swipeAction.isEnabled else { return }
                horizontalOffset = boundedOffset(for: value.translation.width)
            }
            .onEnded { _ in
                guard let swipeAction, swipeAction.isEnabled else {
                    horizontalOffset = 0
                    return
                }

                if horizontalOffset >= SwipeMetrics.triggerOffset {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    swipeAction.onTrigger()
                }
                horizontalOffset = 0
            }
    }

    private func swipeBackground(for configuration: SwipeActionConfiguration) -> some View {
        HStack(spacing: 10) {
            Image(systemName: swipeProgress >= 1 ? configuration.symbolName : "arrow.right.circle.fill")
                .font(.title3.weight(.semibold))
            Text(configuration.title)
                .font(.subheadline.weight(.semibold))
        }
        .foregroundStyle(.white)
        .padding(.leading, 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [configuration.tint.opacity(0.45), configuration.tint.opacity(0.85)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(max(0.2, swipeProgress))
        )
        .opacity(configuration.isEnabled ? max(0.35, swipeProgress) : 0)
    }

    private var swipeProgress: CGFloat {
        min(max(horizontalOffset / SwipeMetrics.triggerOffset, 0), 1)
    }

    private func boundedOffset(for translation: CGFloat) -> CGFloat {
        let clamped = max(0, translation)
        guard clamped > SwipeMetrics.maxOffset else {
            return clamped
        }
        let overshoot = clamped - SwipeMetrics.maxOffset
        return SwipeMetrics.maxOffset + (overshoot * 0.2)
    }
}

private extension View {
    @ViewBuilder
    func applyIf<Transformed: View>(
        _ condition: Bool,
        transform: (Self) -> Transformed
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
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
