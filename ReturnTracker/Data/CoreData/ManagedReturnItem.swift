import CoreData
import Foundation

@objc(ManagedReturnItem)
final class ManagedReturnItem: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ManagedReturnItem> {
        NSFetchRequest<ManagedReturnItem>(entityName: "ManagedReturnItem")
    }

    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var detail: String?
    @NSManaged var createdAt: Date
    @NSManaged var returnDate: Date?
    @NSManaged var isReturned: Bool
}
