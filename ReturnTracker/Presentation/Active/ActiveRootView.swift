//
//  ActiveRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

struct ActiveReturnItem: Identifiable, ProductMainCellPresentable {
    let id = UUID()
    let titleText: String
    let subtitleText: String
    let badgeText: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
}

struct ActiveRootView: View {
    private let items: [ActiveReturnItem] = [
        ActiveReturnItem(
            titleText: "Amazon — Running Shoes",
            subtitleText: "Last day: Jan 28, 2026",
            badgeText: "9d",
            primaryButtonTitle: "Returned",
            secondaryButtonTitle: "Archive"
        ),
        ActiveReturnItem(
            titleText: "Hepsiburada — Coffee Machine",
            subtitleText: "Last day: Feb 6, 2026",
            badgeText: "18d",
            primaryButtonTitle: "Returned",
            secondaryButtonTitle: "Archive"
        )
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(items) { item in
                    ProductMainCell(
                        viewModel: item,
                        onPrimaryTap: {},
                        onSecondaryTap: {}
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Active")
    }
}

#Preview {
    NavigationStack {
        ActiveRootView()
    }
}
