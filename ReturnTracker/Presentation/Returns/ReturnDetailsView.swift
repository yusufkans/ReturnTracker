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
                    SectionHeaderView(title: NSLocalizedString("details.overview", comment: "Overview section header"))

                    RoundedCardCell {
                        // Overview info row container.
                        VStack(alignment: .leading, spacing: 16) {
                            InfoRowView(title: NSLocalizedString("details.created", comment: "Created row title"), value: viewModel.createdAtText)
                            Divider()
                            // Status summary row.
                            InfoRowView(
                                title: NSLocalizedString("details.status", comment: "Status row title"),
                                value: viewModel.isReturned
                                    ? NSLocalizedString("returns.status.returned", comment: "Returned status text")
                                    : NSLocalizedString("returns.status.active", comment: "Active status text")
                            )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: NSLocalizedString("details.section.title", comment: "Details section header"))

                    RoundedCardCell {
                        // Editable detail fields and save action.
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
                                title: NSLocalizedString("details.return_date", comment: "Return date field label"),
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
                                Text(NSLocalizedString("details.action.save_changes", comment: "Save changes button title"))
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: NSLocalizedString("details.actions", comment: "Actions section header"))

                    // Primary and secondary actions stacked for quick access.
                    VStack(spacing: 12) {
                        Button(action: {
                            if viewModel.markReturned() {
                                onUpdate()
                            }
                        }) {
                            Text(NSLocalizedString("returns.action.mark_returned", comment: "Mark returned button title"))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)

                        Button(action: {
                            if viewModel.archive() {
                                onUpdate()
                            }
                        }) {
                            Text(NSLocalizedString("returns.action.archive", comment: "Archive button title"))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding()
            .adaptiveBottomSheetContentHeightSource()
        }
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text(alert.title),
                message: alert.message.map { Text($0) },
                dismissButton: .default(Text(NSLocalizedString("common.ok", comment: "OK button title")))
            )
        }
        .sheet(isPresented: $isShowingReturnDatePicker) {
            DatePickerSheetView(
                title: NSLocalizedString("details.return_date", comment: "Return date picker title"),
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
        title: NSLocalizedString("preview.item_name", comment: "Preview item name"),
        detail: NSLocalizedString("preview.store_name", comment: "Preview store name"),
        createdAt: Date(),
        returnDate: Calendar.current.date(byAdding: .day, value: 4, to: Date()),
        isReturned: false
    )
    let repository = PreviewReturnItemRepository(items: [item])
    ReturnDetailsView(viewModel: ReturnDetailsViewModel(item: item, repository: repository)) {}
}
#endif
