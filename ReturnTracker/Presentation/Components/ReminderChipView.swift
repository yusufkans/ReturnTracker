//
//  ReminderChipView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 21.01.2026.
//

import SwiftUI

struct ReminderChipView: View {
    private let title: String
    @Binding private var isSelected: Bool

    init(title: String, isSelected: Binding<Bool>) {
        self.title = title
        self._isSelected = isSelected
    }

    var body: some View {
        Button(action: { isSelected.toggle() }) {
            HStack(spacing: 8) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.subheadline.weight(.semibold))
                }

                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundStyle(isSelected ? Color.white : Color.accentColor)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? Color.accentColor : Color.accentColor.opacity(0.12))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ReminderChipView(title: "7 days before", isSelected: .constant(true))
        .padding()
}
