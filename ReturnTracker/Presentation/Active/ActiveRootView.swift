//
//  ActiveRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct ActiveRootView: View {
    @State private var isShowingFilePicker = false
    @State private var uploadedFileName: String?

    @State private var itemName = ""
    @State private var storeName = ""
    @State private var isShowingPurchaseDatePicker = false
    @State private var draftPurchaseDate = Date()
    @State private var selectedPurchaseDate: Date?

    @State private var reminderSevenDaysBefore = true
    @State private var reminderTwoDaysBefore = true
    @State private var reminderLastDay = true

    private var purchaseDateText: String {
        guard let selectedPurchaseDate else {
            return "Select date"
        }

        return selectedPurchaseDate.formatted(date: .abbreviated, time: .omitted)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: "Quick Add")

                    UploadSelectionCard(
                        title: "Upload Image/PDF",
                        subtitle: "We'll suggest the date/store if we can. You can edit anything.",
                        selectedFileName: uploadedFileName
                    ) {
                        isShowingFilePicker = true
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: "Manual Add")

                    RoundedCardCell {
                        VStack(alignment: .leading, spacing: 16) {
                            LabeledTextFieldRow(
                                title: "Item name",
                                placeholder: "e.g., Wireless Headphones",
                                text: $itemName
                            )

                            Divider()

                            LabeledTextFieldRow(
                                title: "Store name",
                                placeholder: "e.g., Apple Store",
                                text: $storeName
                            )

                            Divider()

                            SelectableRow(
                                title: "Purchase date",
                                value: purchaseDateText
                            ) {
                                draftPurchaseDate = selectedPurchaseDate ?? Date()
                                isShowingPurchaseDatePicker = true
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: "Reminders")

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 140), spacing: 12)],
                        alignment: .leading,
                        spacing: 12
                    ) {
                        ReminderChipView(
                            title: "7 days before",
                            isSelected: $reminderSevenDaysBefore
                        )
                        ReminderChipView(
                            title: "2 days before",
                            isSelected: $reminderTwoDaysBefore
                        )
                        ReminderChipView(
                            title: "On last day",
                            isSelected: $reminderLastDay
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Quick Add")
        .fileImporter(
            isPresented: $isShowingFilePicker,
            allowedContentTypes: [.image, .pdf]
        ) { result in
            switch result {
            case .success(let url):
                uploadedFileName = url.lastPathComponent
            case .failure:
                uploadedFileName = nil
            }
        }
        .sheet(isPresented: $isShowingPurchaseDatePicker) {
            DatePickerSheetView(
                title: "Purchase date",
                selection: $draftPurchaseDate,
                onSave: {
                    selectedPurchaseDate = draftPurchaseDate
                    isShowingPurchaseDatePicker = false
                },
                onCancel: {
                    isShowingPurchaseDatePicker = false
                }
            )
        }
    }
}

#Preview {
    NavigationStack {
        ActiveRootView()
    }
}
