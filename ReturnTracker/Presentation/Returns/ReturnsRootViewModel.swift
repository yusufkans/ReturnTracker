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
    let isPrimaryButtonEnabled: Bool
    let isSecondaryButtonEnabled: Bool
    let item: ReturnItem
}

@MainActor
final class ReturnsRootViewModel: ObservableObject {
    @Published private(set) var items: [ReturnItem] = []
    @Published var toast: ToastState?

    private let repository: ReturnItemRepository
    private let statusPolicy: ReturnItemStatusEvaluating
    private let toastScheduler: ToastScheduler
    private var toastTask: Task<Void, Never>?

    init(
        repository: ReturnItemRepository,
        statusPolicy: ReturnItemStatusEvaluating = ReturnItemStatusPolicy(),
        toastScheduler: ToastScheduler = DefaultToastScheduler()
    ) {
        self.repository = repository
        self.statusPolicy = statusPolicy
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
                return item.isArchived == false
            case .archive:
                return item.isArchived
            }
        }
        return filtered.map { ReturnItemCellViewModel(from: $0, statusPolicy: statusPolicy) }
    }

    @discardableResult
    func markReturned(for item: ReturnItem) -> Bool {
        guard statusPolicy.canMarkReturned(item) else {
            return false
        }
        do {
            try repository.save(statusPolicy.markReturned(item))
            load()
            return true
        } catch {
            return false
        }
    }

    @discardableResult
    func toggleArchive(for item: ReturnItem) -> Bool {
        if item.isArchived {
            guard statusPolicy.canUnarchive(item) else {
                return false
            }
            return update(item: statusPolicy.unarchive(item))
        }
        return update(item: statusPolicy.archive(item))
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
    private func update(item: ReturnItem) -> Bool {
        do {
            try repository.save(item)
            load()
            return true
        } catch {
            return false
        }
    }
}

private extension ReturnItemCellViewModel {
    init(from item: ReturnItem, statusPolicy: ReturnItemStatusEvaluating) {
        id = item.id
        titleText = item.title
        subtitleText = ReturnItemCellViewModel.makeSubtitle(for: item)
        badgeText = ReturnItemCellViewModel.makeBadgeText(for: item)
        primaryButtonTitle = item.isReturned
            ? L10n.Returns.actionReturned
            : L10n.Returns.actionMarkReturned
        secondaryButtonTitle = item.isArchived
            ? L10n.Returns.actionUnarchive
            : L10n.Returns.actionArchive
        isPrimaryButtonEnabled = statusPolicy.canMarkReturned(item)
        isSecondaryButtonEnabled = item.isArchived ? statusPolicy.canUnarchive(item) : true
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
