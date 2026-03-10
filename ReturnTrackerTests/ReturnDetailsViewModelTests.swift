import XCTest
@testable import ReturnTracker

@MainActor
final class ReturnDetailsViewModelTests: XCTestCase {
    func testMarkReturnedRollsBackStatusWhenSaveFailsValidation() {
        let item = ReturnItem(title: "Phone", isReturned: false, isArchived: false)
        let repository = FailingRepository()
        let viewModel = ReturnDetailsViewModel(item: item, repository: repository)
        viewModel.itemName = "   "

        let result = viewModel.markReturned()

        XCTAssertFalse(result)
        XCTAssertFalse(viewModel.isReturned)
        XCTAssertFalse(viewModel.isArchived)
    }

    func testArchiveRollsBackStatusWhenSaveThrows() {
        let item = ReturnItem(title: "Phone", isReturned: false, isArchived: false)
        let repository = FailingRepository()
        let viewModel = ReturnDetailsViewModel(item: item, repository: repository)

        let result = viewModel.archive()

        XCTAssertFalse(result)
        XCTAssertFalse(viewModel.isReturned)
        XCTAssertFalse(viewModel.isArchived)
    }
}

private final class FailingRepository: ReturnItemRepository {
    func fetchAll() throws -> [ReturnItem] { [] }
    func fetchActive() throws -> [ReturnItem] { [] }
    func save(_ item: ReturnItem) throws { throw TestError.saveFailed }
    func delete(id: UUID) throws {}

    private enum TestError: Error {
        case saveFailed
    }
}
