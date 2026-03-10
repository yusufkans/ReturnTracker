//
//  NewRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import CoreData
import Foundation
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
                    SectionHeaderView(title: NSLocalizedString("new.quick_add", comment: "Quick add section header"))

                    UploadSelectionCard(
                        title: NSLocalizedString("new.upload.title", comment: "Upload card title"),
                        subtitle: NSLocalizedString("new.upload.subtitle.long", comment: "Upload card subtitle"),
                        selectedFileName: uploadedFileName
                    ) {
                        isShowingFilePicker = true
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: NSLocalizedString("new.manual_add", comment: "Manual add section header"))

                    RoundedCardCell {
                        VStack(alignment: .leading, spacing: 16) {
                            LabeledTextFieldRow(
                                title: NSLocalizedString("new.item_name", comment: "Item name field label"),
                                placeholder: NSLocalizedString("new.item_name.placeholder", comment: "Item name placeholder"),
                                text: $viewModel.itemName
                            )

                            Divider()

                            LabeledTextFieldRow(
                                title: NSLocalizedString("new.store_name", comment: "Store name field label"),
                                placeholder: NSLocalizedString("new.store_name.placeholder", comment: "Store name placeholder"),
                                text: $viewModel.storeName
                            )

                            Divider()

                            SelectableRow(
                                title: NSLocalizedString("new.purchase_date", comment: "Purchase date field label"),
                                value: viewModel.purchaseDateText
                            ) {
                                draftPurchaseDate = viewModel.selectedPurchaseDate ?? Date()
                                isShowingPurchaseDatePicker = true
                            }

                            Divider()

                            Button(action: {
                                viewModel.save()
                            }) {
                                Text(NSLocalizedString("new.action.save_item", comment: "Save item button title"))
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(viewModel.itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: NSLocalizedString("new.reminders", comment: "Reminders section header"))

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 140), spacing: 12)],
                        alignment: .leading,
                        spacing: 12
                    ) {
                        ReminderChipView(
                            title: NSLocalizedString("new.reminder.seven_days", comment: "Reminder option title"),
                            isSelected: $viewModel.reminderSevenDaysBefore
                        )
                        ReminderChipView(
                            title: NSLocalizedString("new.reminder.two_days", comment: "Reminder option title"),
                            isSelected: $viewModel.reminderTwoDaysBefore
                        )
                        ReminderChipView(
                            title: NSLocalizedString("new.reminder.last_day", comment: "Reminder option title"),
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
                dismissButton: .default(Text(NSLocalizedString("common.ok", comment: "OK button title")))
            )
        }
        .navigationTitle(NSLocalizedString("new.quick_add", comment: "Quick add screen title"))
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
                title: NSLocalizedString("new.purchase_date", comment: "Purchase date picker title"),
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
