//
//  DatePickerSheetView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 21.01.2026.
//

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
                    Button("Cancel", action: onCancel)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: onSave)
                }
            }
        }
    }
}

#Preview {
    DatePickerSheetView(
        title: "Purchase date",
        selection: .constant(Date()),
        onSave: {},
        onCancel: {}
    )
}
