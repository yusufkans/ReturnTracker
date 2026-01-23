//
//  ReturnDetailsViewModel.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 01.02.2026.
//

import Foundation

struct ReturnDetailsAlertState: Identifiable {
    let id = UUID()
    let title: String
    let message: String?
}

@MainActor
final class ReturnDetailsViewModel: ObservableObject {
    @Published var itemName: String
    @Published var storeName: String
    @Published var returnDate: Date?
    @Published private(set) var isReturned: Bool
    @Published var alert: ReturnDetailsAlertState?

    private let repository: ReturnItemRepository
    private let originalItem: ReturnItem

    init(item: ReturnItem, repository: ReturnItemRepository) {
        self.originalItem = item
        self.repository = repository
        self.itemName = item.title
        self.storeName = item.detail ?? ""
        self.returnDate = item.returnDate
        self.isReturned = item.isReturned
    }

    var createdAtText: String {
        originalItem.createdAt.formatted(date: .abbreviated, time: .omitted)
    }

    var returnDateText: String {
        guard let returnDate else {
            return "Select date"
        }
        return returnDate.formatted(date: .abbreviated, time: .omitted)
    }

    @discardableResult
    func save() -> Bool {
        let trimmedItemName = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedItemName.isEmpty else {
            alert = ReturnDetailsAlertState(
                title: "Missing item name",
                message: "Please add an item name before saving."
            )
            return false
        }

        let trimmedStoreName = storeName.trimmingCharacters(in: .whitespacesAndNewlines)
        let detail = trimmedStoreName.isEmpty ? nil : trimmedStoreName

        let updatedItem = ReturnItem(
            id: originalItem.id,
            title: trimmedItemName,
            detail: detail,
            createdAt: originalItem.createdAt,
            returnDate: returnDate,
            isReturned: isReturned
        )

        do {
            try repository.save(updatedItem)
            alert = ReturnDetailsAlertState(title: "Saved", message: "Item updated successfully.")
            return true
        } catch {
            alert = ReturnDetailsAlertState(title: "Save failed", message: error.localizedDescription)
            return false
        }
    }

    @discardableResult
    func markReturned() -> Bool {
        isReturned = true
        return save()
    }

    @discardableResult
    func archive() -> Bool {
        isReturned = true
        return save()
    }
}
