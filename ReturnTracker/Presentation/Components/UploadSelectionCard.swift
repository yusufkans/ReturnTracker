//
//  UploadSelectionCard.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 21.01.2026.
//

import SwiftUI

struct UploadSelectionCard: View {
    private let title: String
    private let subtitle: String
    private let selectedFileName: String?
    private let onTap: () -> Void

    init(
        title: String,
        subtitle: String,
        selectedFileName: String? = nil,
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.selectedFileName = selectedFileName
        self.onTap = onTap
    }

    var body: some View {
        RoundedCardCell {
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3)
                            .foregroundStyle(.primary)

                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }

                    Text(selectedFileName ?? subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    UploadSelectionCard(
        title: "Upload Image/PDF",
        subtitle: "We'll suggest the date/store if we can."
    ) {}
    .padding()
}
