import XCTest
@testable import ReturnTracker

final class ReturnItemStatusPolicyTests: XCTestCase {
    private let calendar = Calendar(identifier: .gregorian)

    func testMarkReturnedMovesItemToArchive() {
        let policy = ReturnItemStatusPolicy(calendar: calendar)
        let item = ReturnItem(title: "Headphones", isReturned: false, isArchived: false)

        let updated = policy.markReturned(item)

        XCTAssertTrue(updated.isReturned)
        XCTAssertTrue(updated.isArchived)
    }

    func testArchivedNotReturnedItemCanBeReturnedWhileNotExpired() {
        let policy = ReturnItemStatusPolicy(calendar: calendar)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let item = ReturnItem(title: "Keyboard", returnDate: tomorrow, isReturned: false, isArchived: true)

        XCTAssertTrue(policy.canMarkReturned(item))
        XCTAssertTrue(policy.canUnarchive(item))
    }

    func testExpiredArchivedItemCannotBeReturnedOrUnarchived() {
        let policy = ReturnItemStatusPolicy(calendar: calendar)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        let item = ReturnItem(title: "Mouse", returnDate: yesterday, isReturned: false, isArchived: true)

        XCTAssertFalse(policy.canMarkReturned(item))
        XCTAssertFalse(policy.canUnarchive(item))
    }
}
