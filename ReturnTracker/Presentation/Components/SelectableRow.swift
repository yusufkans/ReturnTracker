//
//  SelectableRow.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 21.01.2026.
//

import SwiftUI

struct SelectableRow: View {
    private let title: String
    private let value: String
    private let onTap: () -> Void

    init(title: String, value: String, onTap: @escaping () -> Void) {
        self.title = title
        self.value = value
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Spacer()

                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SelectableRow(title: "Purchase date", value: "Select date") {}
        .padding()
}
