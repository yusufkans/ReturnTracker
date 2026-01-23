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
}

@MainActor
final class ReturnsRootViewModel: ObservableObject {
    @Published private(set) var items: [ReturnItem] = []

    private let repository: ReturnItemRepository

    init(repository: ReturnItemRepository) {
        self.repository = repository
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
}

private extension ReturnItemCellViewModel {
    init(from item: ReturnItem) {
        id = item.id
        titleText = item.title
        subtitleText = ReturnItemCellViewModel.makeSubtitle(for: item)
        badgeText = ReturnItemCellViewModel.makeBadgeText(for: item)
        primaryButtonTitle = item.isReturned ? "Returned" : "Mark Returned"
        secondaryButtonTitle = item.isReturned ? "Unarchive" : "Archive"
    }

    static func makeSubtitle(for item: ReturnItem) -> String {
        guard let returnDate = item.returnDate else {
            return "Return date: TBD"
        }
        return "Last day: \(dateFormatter.string(from: returnDate))"
    }

    static func makeBadgeText(for item: ReturnItem) -> String {
        guard let returnDate = item.returnDate else {
            return "—"
        }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: returnDate).day ?? 0
        return "\(max(days, 0))d"
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
