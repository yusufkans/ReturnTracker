//
//  ProductMainCell.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 20.01.2026.
//

import SwiftUI

protocol ProductMainCellPresentable {
    var titleText: String { get }
    var subtitleText: String { get }
    var badgeText: String { get }
    var primaryButtonTitle: String { get }
    var secondaryButtonTitle: String { get }
}

struct ProductMainCell<ViewModel: ProductMainCellPresentable>: View {
    private let viewModel: ViewModel
    private let onCellTap: () -> Void
    private let onPrimaryTap: () -> Void
    private let onSecondaryTap: () -> Void

    init(
        viewModel: ViewModel,
        onCellTap: @escaping () -> Void,
        onPrimaryTap: @escaping () -> Void,
        onSecondaryTap: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onCellTap = onCellTap
        self.onPrimaryTap = onPrimaryTap
        self.onSecondaryTap = onSecondaryTap
    }
    
    var body: some View {
        RoundedCardCell {
            VStack(alignment: .leading, spacing: 12) {
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

                HStack(spacing: 12) {
                    Button(viewModel.primaryButtonTitle, action: onPrimaryTap)
                        .buttonStyle(.bordered)
                        .frame(width: .infinity)
                    
                    Spacer()
                    
                    Button(viewModel.secondaryButtonTitle, action: onSecondaryTap)
                        .buttonStyle(.plain)
                        .frame(width: .infinity)
                }
            }
        }
        .shadow(color: Color.green, radius: 0.1, x: -4)
        .onTapGesture {
            onCellTap()
        }
    }
}

private struct PreviewModel: ProductMainCellPresentable {
    let titleText = "Amazon — Running Shoes"
    let subtitleText = "Last day: Jan 28, 2026"
    let badgeText = "9d"
    let primaryButtonTitle = "Returned"
    let secondaryButtonTitle = "Archive"
}

#Preview {
    ProductMainCell(viewModel: PreviewModel(), onCellTap: {}, onPrimaryTap: {}, onSecondaryTap: {})
        .padding()
}
