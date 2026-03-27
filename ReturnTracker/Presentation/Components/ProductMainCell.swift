//
//  ProductMainCell.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 20.01.2026.
//

import Foundation
import SwiftUI
import UIKit

protocol ProductMainCellPresentable {
    var titleText: String { get }
    var subtitleText: String { get }
    var badgeText: String { get }
}

struct ProductMainCell<ViewModel: ProductMainCellPresentable>: View {
    private enum SwipeMetrics {
        static let maxOffset: CGFloat = 220
        static let triggerOffset: CGFloat = 165
    }

    private let viewModel: ViewModel
    private let onCellTap: () -> Void
    private let onMarkReturned: () -> Void
    private let isReturned: Bool

    @State private var horizontalOffset: CGFloat = 0

    init(
        viewModel: ViewModel,
        onCellTap: @escaping () -> Void,
        isReturned: Bool,
        onMarkReturned: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onCellTap = onCellTap
        self.isReturned = isReturned
        self.onMarkReturned = onMarkReturned
    }
    
    var body: some View {
        RoundedCardCell {
            ZStack(alignment: .leading) {
                swipeBackground

                foregroundContent
                    .offset(x: horizontalOffset)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .gesture(swipeGesture)
            .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.82), value: horizontalOffset)
        }
        .shadow(color: Color.green, radius: 0.1, x: -4)
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onChanged { value in
                guard isReturned == false else { return }
                horizontalOffset = boundedOffset(for: value.translation.width)
            }
            .onEnded { _ in
                guard isReturned == false else {
                    horizontalOffset = 0
                    return
                }

                if horizontalOffset >= SwipeMetrics.triggerOffset {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onMarkReturned()
                }
                horizontalOffset = 0
            }
    }

    private var foregroundContent: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.titleText)
                    .font(.headline)
                Text(viewModel.subtitleText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Text(viewModel.badgeText)
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
        )
        .onTapGesture {
            onCellTap()
        }
    }

    private var swipeBackground: some View {
        HStack(spacing: 10) {
            Image(systemName: swipeProgress >= 1 ? "checkmark.circle.fill" : "arrow.right.circle.fill")
                .font(.title3.weight(.semibold))

            Text(L10n.Returns.actionMarkReturned)
                .font(.subheadline.weight(.semibold))
        }
        .foregroundStyle(.white)
        .padding(.leading, 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.green.opacity(0.45), Color.green.opacity(0.85)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(max(0.2, swipeProgress))
        )
        .opacity(isReturned ? 0 : max(0.35, swipeProgress))
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

private struct PreviewModel: ProductMainCellPresentable {
    let titleText = L10n.Preview.productTitle
    let subtitleText = L10n.Preview.productSubtitle
    let badgeText = L10n.Preview.productBadge
}

#Preview {
    ProductMainCell(viewModel: PreviewModel(), onCellTap: {}, isReturned: false, onMarkReturned: {})
        .padding()
}
