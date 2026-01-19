//
//  ActiveRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

struct ActiveReturnItem: Identifiable {
    let id = UUID()
    let title: String
    let lastDay: String
    let remainingDays: String
}

struct ActiveRootView: View {
    private let items: [ActiveReturnItem] = [
        ActiveReturnItem(title: "Amazon — Running Shoes", lastDay: "Jan 28, 2026", remainingDays: "9d"),
        ActiveReturnItem(title: "Hepsiburada — Coffee Machine", lastDay: "Feb 6, 2026", remainingDays: "18d")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(items) { item in
                    RoundedCardCell {
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.title)
                                    .font(.headline)
                                Text("Last day: \(item.lastDay)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer(minLength: 0)

                            Text(item.remainingDays)
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
