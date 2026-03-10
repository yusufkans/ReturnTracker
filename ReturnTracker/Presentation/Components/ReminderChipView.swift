//
//  ReminderChipView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 21.01.2026.
//

import Foundation
import SwiftUI

struct ReminderChipView: View {
    private let title: String
    @Binding private var isSelected: Bool

    init(title: String, isSelected: Binding<Bool>) {
        self.title = title
        self._isSelected = isSelected
    }

    var body: some View {
        Button {
            withAnimation(AppAnimation.action) {
                isSelected.toggle()
            }
        } label: {
            HStack(spacing: 8) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption.weight(.bold))
                }

                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .foregroundStyle(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ReminderChipView(
        title: NSLocalizedString("new.reminder.seven_days", comment: "Reminder option for seven days before"),
        isSelected: .constant(true)
    )
    .padding()
}
