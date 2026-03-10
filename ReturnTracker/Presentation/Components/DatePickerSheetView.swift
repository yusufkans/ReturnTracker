//
//  DatePickerSheetView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 21.01.2026.
//

import Foundation
import SwiftUI

struct DatePickerSheetView: View {
    private let title: String
    @Binding private var selection: Date
    private let onSave: () -> Void
    private let onCancel: () -> Void

    init(
        title: String,
        selection: Binding<Date>,
        onSave: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self._selection = selection
        self.onSave = onSave
        self.onCancel = onCancel
    }

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "",
                    selection: $selection,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("common.cancel", comment: "Cancel button title"), action: onCancel)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("common.save", comment: "Save button title"), action: onSave)
                }
            }
        }
    }
}

#Preview {
    DatePickerSheetView(
        title: NSLocalizedString("new.purchase_date", comment: "Purchase date picker title"),
        selection: .constant(Date()),
        onSave: {},
        onCancel: {}
    )
}
