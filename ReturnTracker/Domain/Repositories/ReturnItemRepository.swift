import Foundation

protocol ReturnItemRepository {
    func fetchAll() throws -> [ReturnItem]
    func fetchActive() throws -> [ReturnItem]
    func save(_ item: ReturnItem) throws
    func delete(id: UUID) throws
}
