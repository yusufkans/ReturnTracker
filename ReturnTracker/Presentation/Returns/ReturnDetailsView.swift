//
//  ReturnDetailsView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 01.02.2026.
//

import CoreData
import SwiftUI

struct ReturnDetailsView: View {
    @StateObject private var viewModel: ReturnDetailsViewModel
    @State private var isShowingReturnDatePicker = false
    @State private var draftReturnDate = Date()
    private let onUpdate: () -> Void

    init(viewModel: ReturnDetailsViewModel, onUpdate: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onUpdate = onUpdate
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: "Overview")

                    RoundedCardCell {
                        VStack(alignment: .leading, spacing: 16) {
                            InfoRowView(title: "Created", value: viewModel.createdAtText)
                            Divider()
                            InfoRowView(
                                title: "Status",
                                value: viewModel.isReturned ? "Returned" : "Active"
                            )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: "Details")

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
                                title: "Return date",
                                value: viewModel.returnDateText
                            ) {
                                draftReturnDate = viewModel.returnDate ?? Date()
                                isShowingReturnDatePicker = true
                            }

                            Divider()

                            Button(action: {
                                if viewModel.save() {
                                    onUpdate()
                                }
                            }) {
                                Text("Save Changes")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: "Actions")

                    VStack(spacing: 12) {
                        Button(action: {
                            if viewModel.markReturned() {
                                onUpdate()
                            }
                        }) {
                            Text("Mark Returned")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)

                        Button(action: {
                            if viewModel.archive() {
                                onUpdate()
                            }
                        }) {
                            Text("Archive")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
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
        .sheet(isPresented: $isShowingReturnDatePicker) {
            DatePickerSheetView(
                title: "Return date",
                selection: $draftReturnDate,
                onSave: {
                    viewModel.returnDate = draftReturnDate
                    isShowingReturnDatePicker = false
                },
                onCancel: {
                    isShowingReturnDatePicker = false
                }
            )
        }
    }
}

private struct InfoRowView: View {
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            Spacer()

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    let item = ReturnItem(
        title: "Wireless Headphones",
        detail: "Apple Store",
        createdAt: Date(),
        returnDate: Calendar.current.date(byAdding: .day, value: 4, to: Date()),
        isReturned: false
    )
    let repository = CoreDataReturnItemRepository(store: try! CoreDataStack(storeType: NSInMemoryStoreType))
    ReturnDetailsView(viewModel: ReturnDetailsViewModel(item: item, repository: repository)) {}
}
