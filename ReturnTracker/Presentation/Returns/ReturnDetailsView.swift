//
//  ReturnDetailsView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 01.02.2026.
//

import Foundation
import SwiftUI

struct ReturnDetailsView: View {
    @StateObject private var viewModel: ReturnDetailsViewModel
    private let onUpdate: () -> Void
    @State private var isShowingReturnDatePicker = false
    @State private var draftReturnDate = Date()

    init(viewModel: ReturnDetailsViewModel, onUpdate: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onUpdate = onUpdate
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: L10n.Details.overview)

                    RoundedCardCell {
                        // Overview info row container.
                        VStack(alignment: .leading, spacing: 16) {
                            InfoRowView(title: L10n.Details.created, value: viewModel.createdAtText)
                            Divider()
                            // Status summary row.
                            InfoRowView(
                                title: L10n.Details.status,
                                value: viewModel.isReturned
                                    ? L10n.Returns.statusReturned
                                    : L10n.Returns.statusActive
                            )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: L10n.Details.sectionTitle)

                    RoundedCardCell {
                        // Editable detail fields and save action.
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
                                title: L10n.Details.returnDate,
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
                                Text(L10n.Details.saveChanges)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: L10n.Details.actions)

                    Button(action: {
                        if viewModel.markReturned() {
                            onUpdate()
                        }
                    }) {
                        Text(L10n.Returns.actionMarkReturned)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isReturned)
                }
            }
            .padding()
            .adaptiveBottomSheetContentHeightSource()
        }
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text(alert.title),
                message: alert.message.map { Text($0) },
                dismissButton: .default(Text(L10n.Common.ok))
            )
        }
        .sheet(isPresented: $isShowingReturnDatePicker) {
            DatePickerSheetView(
                title: L10n.Details.returnDate,
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

#if DEBUG
private final class PreviewReturnItemRepository: ReturnItemRepository {
    private var items: [ReturnItem]

    init(items: [ReturnItem]) {
        self.items = items
    }

    func fetchAll() throws -> [ReturnItem] {
        items
    }

    func fetchActive() throws -> [ReturnItem] {
        items.filter { $0.isReturned == false }
    }

    func save(_ item: ReturnItem) throws {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }

    func delete(id: UUID) throws {
        items.removeAll { $0.id == id }
    }
}

#Preview {
    let item = ReturnItem(
        title: L10n.Preview.itemName,
        detail: L10n.Preview.storeName,
        createdAt: Date(),
        returnDate: Calendar.current.date(byAdding: .day, value: 4, to: Date()),
        isReturned: false
    )
    let repository = PreviewReturnItemRepository(items: [item])
    ReturnDetailsView(viewModel: ReturnDetailsViewModel(item: item, repository: repository)) {}
}
#endif
