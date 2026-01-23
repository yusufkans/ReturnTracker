//
//  NewRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import CoreData
import SwiftUI
import UniformTypeIdentifiers

struct NewRootView: View {
    @StateObject private var viewModel: NewReturnItemViewModel
    @State private var isShowingFilePicker = false
    @State private var uploadedFileName: String?
    @State private var isShowingPurchaseDatePicker = false
    @State private var draftPurchaseDate = Date()

    init(viewModel: NewReturnItemViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
                                text: $viewModel.itemName
                            )

                            Divider()

                            LabeledTextFieldRow(
                                title: "Store name",
                                placeholder: "e.g., Apple Store",
                                text: $viewModel.storeName
                            )

                            Divider()

                            SelectableRow(
                                title: "Purchase date",
                                value: viewModel.purchaseDateText
                            ) {
                                draftPurchaseDate = viewModel.selectedPurchaseDate ?? Date()
                                isShowingPurchaseDatePicker = true
                            }

                            Divider()

                            Button(action: {
                                viewModel.save()
                            }) {
                                Text("Save Item")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(viewModel.itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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
                            isSelected: $viewModel.reminderSevenDaysBefore
                        )
                        ReminderChipView(
                            title: "2 days before",
                            isSelected: $viewModel.reminderTwoDaysBefore
                        )
                        ReminderChipView(
                            title: "On last day",
                            isSelected: $viewModel.reminderLastDay
                        )
                    }
                }
            }
            .padding()
        }
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text(alert.title),
                message: alert.message.map { Text($0) },
                dismissButton: .default(Text("OK"))
            )
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
                    viewModel.selectedPurchaseDate = draftPurchaseDate
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
        let repository = CoreDataReturnItemRepository(store: try! CoreDataStack(storeType: NSInMemoryStoreType))
        let useCase = DefaultCreateReturnItemUseCase(repository: repository)
        NewRootView(viewModel: NewReturnItemViewModel(createUseCase: useCase))
    }
}
