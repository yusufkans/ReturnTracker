//
//  ProductMainCell.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 20.01.2026.
//

import Foundation
import SwiftUI

protocol ProductMainCellPresentable {
    var titleText: String { get }
    var subtitleText: String { get }
    var badgeText: String { get }
}

struct ProductMainCell<ViewModel: ProductMainCellPresentable>: View {
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
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.green.opacity(swipeProgress * 0.25))

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
            }
            .offset(x: horizontalOffset)
            .gesture(swipeGesture)
            .animation(.easeOut(duration: 0.2), value: horizontalOffset)
        }
        .shadow(color: Color.green, radius: 0.1, x: -4)
        .onTapGesture {
            onCellTap()
        }
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onChanged { value in
                guard isReturned == false else { return }
                horizontalOffset = max(0, min(value.translation.width, 130))
            }
            .onEnded { _ in
                guard isReturned == false else {
                    horizontalOffset = 0
                    return
                }

                if horizontalOffset >= 90 {
                    onMarkReturned()
                }
                horizontalOffset = 0
            }
    }

    private var swipeProgress: CGFloat {
        min(max(horizontalOffset / 130, 0), 1)
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
