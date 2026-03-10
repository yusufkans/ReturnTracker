//
//  ReturnDetailsViewModel.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 01.02.2026.
//

import Combine
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
    @Published private(set) var isArchived: Bool
    @Published var alert: ReturnDetailsAlertState?

    private let repository: ReturnItemRepository
    private let statusPolicy: ReturnItemStatusEvaluating
    private let originalItem: ReturnItem

    init(
        item: ReturnItem,
        repository: ReturnItemRepository,
        statusPolicy: ReturnItemStatusEvaluating = ReturnItemStatusPolicy()
    ) {
        self.originalItem = item
        self.repository = repository
        self.statusPolicy = statusPolicy
        self.itemName = item.title
        self.storeName = item.detail ?? ""
        self.returnDate = item.returnDate
        self.isReturned = item.isReturned
        self.isArchived = item.isArchived
    }

    var canMarkReturned: Bool {
        statusPolicy.canMarkReturned(currentItem())
    }

    var canArchive: Bool {
        currentItem().isArchived == false
    }

    var createdAtText: String {
        originalItem.createdAt.formatted(date: .abbreviated, time: .omitted)
    }

    var returnDateText: String {
        guard let returnDate else {
            return L10n.Common.selectDate
        }
        return returnDate.formatted(date: .abbreviated, time: .omitted)
    }

    @discardableResult
    func save() -> Bool {
        let trimmedItemName = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedItemName.isEmpty else {
            alert = ReturnDetailsAlertState(
                title: L10n.Alert.missingItemNameTitle,
                message: L10n.Alert.missingItemNameMessage
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
            isReturned: isReturned,
            isArchived: isArchived
        )

        do {
            try repository.save(updatedItem)
            alert = ReturnDetailsAlertState(
                title: L10n.Alert.savedTitle,
                message: L10n.Alert.savedUpdatedItemMessage
            )
            return true
        } catch {
            alert = ReturnDetailsAlertState(
                title: L10n.Alert.saveFailedTitle,
                message: error.localizedDescription
            )
            return false
        }
    }

    @discardableResult
    func markReturned() -> Bool {
        guard canMarkReturned else {
            return false
        }
        return applyStatusTransition { item in
            statusPolicy.markReturned(item)
        }
    }

    @discardableResult
    func archive() -> Bool {
        guard canArchive else {
            return false
        }
        return applyStatusTransition { item in
            statusPolicy.archive(item)
        }
    }

    @discardableResult
    private func applyStatusTransition(
        _ transition: (ReturnItem) -> ReturnItem
    ) -> Bool {
        let previousStatus = (isReturned: isReturned, isArchived: isArchived)
        let updatedItem = transition(currentItem())
        isReturned = updatedItem.isReturned
        isArchived = updatedItem.isArchived

        guard save() else {
            isReturned = previousStatus.isReturned
            isArchived = previousStatus.isArchived
            return false
        }

        return true
    }

    private func currentItem() -> ReturnItem {
        ReturnItem(
            id: originalItem.id,
            title: itemName,
            detail: storeName,
            createdAt: originalItem.createdAt,
            returnDate: returnDate,
            isReturned: isReturned,
            isArchived: isArchived
        )
    }
}
