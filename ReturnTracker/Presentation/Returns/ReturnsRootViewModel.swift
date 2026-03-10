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

    func items(for segment: ReturnsPageSegments) -> [ReturnItemCellViewModel] {
        let filtered = items.filter { item in
            switch segment {
            case .active:
                return item.isReturned == false
            case .archive:
                return item.isReturned
            }
        }
        return filtered.map { ReturnItemCellViewModel(from: $0) }
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

private extension ReturnItemCellViewModel {
    init(from item: ReturnItem) {
        id = item.id
        titleText = item.title
        subtitleText = ReturnItemCellViewModel.makeSubtitle(for: item)
        badgeText = ReturnItemCellViewModel.makeBadgeText(for: item)
        primaryButtonTitle = item.isReturned
            ? NSLocalizedString("returns.action.returned", comment: "Returned action title")
            : NSLocalizedString("returns.action.mark_returned", comment: "Mark returned action title")
        secondaryButtonTitle = item.isReturned
            ? NSLocalizedString("returns.action.unarchive", comment: "Unarchive action title")
            : NSLocalizedString("returns.action.archive", comment: "Archive action title")
        self.item = item
    }

    static func makeSubtitle(for item: ReturnItem) -> String {
        guard let returnDate = item.returnDate else {
            return NSLocalizedString("returns.date.tbd", comment: "Return date unavailable text")
        }
        let format = NSLocalizedString("returns.last_day.format", comment: "Last day format with date")
        return String(format: format, dateFormatter.string(from: returnDate))
    }

    static func makeBadgeText(for item: ReturnItem) -> String {
        guard let returnDate = item.returnDate else {
            return NSLocalizedString("common.dash", comment: "Placeholder dash")
        }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: returnDate).day ?? 0
        let format = NSLocalizedString("returns.badge.days.format", comment: "Days remaining badge format")
        return String(format: format, max(days, 0))
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
