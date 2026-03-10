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
                    SectionHeaderView(title: L10n.New.quickAdd)

                    UploadSelectionCard(
                        title: L10n.New.uploadTitle,
                        subtitle: L10n.New.uploadSubtitleLong,
                        selectedFileName: uploadedFileName
                    ) {
                        isShowingFilePicker = true
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: L10n.New.manualAdd)

                    RoundedCardCell {
                        VStack(alignment: .leading, spacing: 16) {
                            LabeledTextFieldRow(
                                title: L10n.New.itemName,
                                placeholder: L10n.New.itemNamePlaceholder,
                                text: $viewModel.itemName
                            )

                            Divider()

                            LabeledTextFieldRow(
                                title: L10n.New.storeName,
                                placeholder: L10n.New.storeNamePlaceholder,
                                text: $viewModel.storeName
                            )

                            Divider()

                            SelectableRow(
                                title: L10n.New.purchaseDate,
                                value: viewModel.purchaseDateText
                            ) {
                                draftPurchaseDate = viewModel.selectedPurchaseDate ?? Date()
                                isShowingPurchaseDatePicker = true
                            }

                            Divider()

                            Button(action: {
                                viewModel.save()
                            }) {
                                Text(L10n.New.saveItem)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(viewModel.itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: L10n.New.reminders)
                    

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 140), spacing: 12)],
                        alignment: .leading,
                        spacing: 12
                    ) {
                        ReminderChipView(
                            title: L10n.New.reminderSevenDays,
                            isSelected: $viewModel.reminderSevenDaysBefore
                        )
                        ReminderChipView(
                            title: L10n.New.reminderTwoDays,
                            isSelected: $viewModel.reminderTwoDaysBefore
                        )
                        ReminderChipView(
                            title: L10n.New.reminderLastDay,
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
                dismissButton: .default(Text(L10n.Common.ok))
            )
        }
        .navigationTitle(L10n.New.quickAdd)
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
                title: L10n.New.purchaseDate,

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
