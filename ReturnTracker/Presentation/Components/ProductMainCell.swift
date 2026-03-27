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
        RoundedCardCell(
            swipeAction: .init(
                title: L10n.Returns.actionMarkReturned,
                isEnabled: isReturned == false,
                onTrigger: onMarkReturned
            )
        ) {
            content
        }
        .shadow(color: Color.green, radius: 0.1, x: -4)
    }

    private var content: some View {
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
        .onTapGesture {
            onCellTap()
        }
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
