//
//  ReturnsRootViewModel.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 29.01.2026.
//

import Combine
import CoreData
import Foundation

struct ReturnItemCellViewModel: Identifiable, ProductMainCellPresentable {
    let id: UUID
    let titleText: String
    let subtitleText: String
    let badgeText: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    let item: ReturnItem
}

enum ReturnsSortOption: String, CaseIterable, Identifiable {
    case returnDateNearest
    case returnDateFarthest
    case newestAdded
    case oldestAdded

    var id: String { rawValue }

    var title: String {
        switch self {
        case .returnDateNearest:
            return L10n.Returns.sortNearestReturnDate
        case .returnDateFarthest:
            return L10n.Returns.sortFarthestReturnDate
        case .newestAdded:
            return L10n.Returns.sortNewestAdded
        case .oldestAdded:
            return L10n.Returns.sortOldestAdded
        }
    }
}

@MainActor
final class ReturnsRootViewModel: ObservableObject {
    @Published private(set) var items: [ReturnItem] = []
    @Published var toast: ToastState?

    private let repository: ReturnItemRepository
    private let toastScheduler: ToastScheduler
    private var toastTask: Task<Void, Never>?

    init(repository: ReturnItemRepository, toastScheduler: ToastScheduler = DefaultToastScheduler()) {
        self.repository = repository
        self.toastScheduler = toastScheduler
    }

    func load() {
        do {
            items = try repository.fetchAll()
        } catch {
            items = []
        }
    }

    func items(
        for segment: ReturnsPageSegments,
        matching query: String = "",
        sortedBy sortOption: ReturnsSortOption = .returnDateNearest
    ) -> [ReturnItemCellViewModel] {
        let normalizedQuery = query.normalizedForSearch
        let filtered = items.filter { item in
            let matchesSegment: Bool
            switch segment {
            case .active:
                matchesSegment = item.isReturned == false
            case .archive:
                matchesSegment = item.isReturned
            }

            guard matchesSegment else {
                return false
            }
            guard normalizedQuery.isEmpty == false else {
                return true
            }

            return item.matchesSearchQuery(normalizedQuery)
        }

        let sorted = filtered.sorted { lhs, rhs in
            sortOption.areInIncreasingOrder(lhs: lhs, rhs: rhs)
        }
        return sorted.map { ReturnItemCellViewModel(from: $0) }
    }

    @discardableResult
    func markReturned(for item: ReturnItem) -> Bool {
        updateReturnStatus(for: item, isReturned: true)
    }

    @discardableResult
    func toggleArchive(for item: ReturnItem) -> Bool {
        updateReturnStatus(for: item, isReturned: item.isReturned == false)
    }

    func makeDetailsViewModel(for item: ReturnItem) -> ReturnDetailsViewModel {
        ReturnDetailsViewModel(item: item, repository: repository)
    }

    func showToast(message: String) {
        toastTask?.cancel()
        toast = ToastState(message: message)
        toastTask = toastScheduler.schedule(after: 1_200_000_000) { [weak self] in
            self?.toast = nil
        }
    }

    @discardableResult
    private func updateReturnStatus(for item: ReturnItem, isReturned: Bool) -> Bool {
        var updatedItem = item
        updatedItem.isReturned = isReturned
        do {
            try repository.save(updatedItem)
            load()
            return true
        } catch {
            return false
        }
    }
}

private extension ReturnsSortOption {
    func areInIncreasingOrder(lhs: ReturnItem, rhs: ReturnItem) -> Bool {
        switch self {
        case .returnDateNearest:
            return compareByReturnDate(lhs: lhs, rhs: rhs, ascending: true)
        case .returnDateFarthest:
            return compareByReturnDate(lhs: lhs, rhs: rhs, ascending: false)
        case .newestAdded:
            return lhs.createdAt > rhs.createdAt
        case .oldestAdded:
            return lhs.createdAt < rhs.createdAt
        }
    }

    private func compareByReturnDate(lhs: ReturnItem, rhs: ReturnItem, ascending: Bool) -> Bool {
        switch (lhs.returnDate, rhs.returnDate) {
        case let (left?, right?):
            return ascending ? (left < right) : (left > right)
        case (nil, nil):
            return lhs.createdAt > rhs.createdAt
        case (nil, _?):
            return false
        case (_?, nil):
            return true
        }
    }
}

private extension ReturnItem {
    func matchesSearchQuery(_ normalizedQuery: String) -> Bool {
        title.normalizedForSearch.contains(normalizedQuery)
            || (detail?.normalizedForSearch.contains(normalizedQuery) ?? false)
    }
}

private extension String {
    var normalizedForSearch: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
    }
}

private extension ReturnItemCellViewModel {
    init(from item: ReturnItem) {
        id = item.id
        titleText = item.title
        subtitleText = ReturnItemCellViewModel.makeSubtitle(for: item)
        badgeText = ReturnItemCellViewModel.makeBadgeText(for: item)
        primaryButtonTitle = item.isReturned
            ? L10n.Returns.actionReturned
            : L10n.Returns.actionMarkReturned
        secondaryButtonTitle = item.isReturned
            ? L10n.Returns.actionUnarchive
            : L10n.Returns.actionArchive
        self.item = item
    }

    static func makeSubtitle(for item: ReturnItem) -> String {
        guard let returnDate = item.returnDate else {
            return L10n.Returns.dateTBD
        }
        return L10n.Returns.lastDay(dateFormatter.string(from: returnDate))
    }

    static func makeBadgeText(for item: ReturnItem) -> String {
        guard let returnDate = item.returnDate else {
            return L10n.Common.dash
        }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: returnDate).day ?? 0
        return L10n.Returns.daysBadge(max(days, 0))
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

#if DEBUG
extension ReturnsRootViewModel {
    static func preview() -> ReturnsRootViewModel {
        let stack = try! CoreDataStack(storeType: NSInMemoryStoreType)
        let repository = CoreDataReturnItemRepository(store: stack)
        return ReturnsRootViewModel(repository: repository)
    }
}
#endif
