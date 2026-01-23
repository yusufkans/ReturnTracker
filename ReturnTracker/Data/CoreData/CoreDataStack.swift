import CoreData
import Foundation

protocol CoreDataStoring {
    var mainContext: NSManagedObjectContext { get }
    func newBackgroundContext() -> NSManagedObjectContext
    func save(context: NSManagedObjectContext) throws
}

final class CoreDataStack: CoreDataStoring {
    let mainContext: NSManagedObjectContext

    private let persistentContainer: NSPersistentContainer

    init(storeType: String = NSSQLiteStoreType, storeURL: URL? = nil) throws {
        let model = Self.makeModel()
        let container = NSPersistentContainer(name: "ReturnTracker", managedObjectModel: model)

        let description = NSPersistentStoreDescription()
        description.type = storeType
        if storeType == NSInMemoryStoreType {
            description.url = URL(fileURLWithPath: "/dev/null")
        } else {
            description.url = storeURL ?? Self.defaultStoreURL()
        }
        container.persistentStoreDescriptions = [description]

        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }
        if let loadError {
            throw loadError
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true

        self.persistentContainer = container
        self.mainContext = container.viewContext
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    func save(context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        try context.save()
    }

    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        let entity = NSEntityDescription()
        entity.name = "ManagedReturnItem"
        entity.managedObjectClassName = NSStringFromClass(ManagedReturnItem.self)

        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .UUIDAttributeType
        idAttribute.isOptional = false

        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = false

        let detailAttribute = NSAttributeDescription()
        detailAttribute.name = "detail"
        detailAttribute.attributeType = .stringAttributeType
        detailAttribute.isOptional = true

        let createdAtAttribute = NSAttributeDescription()
        createdAtAttribute.name = "createdAt"
        createdAtAttribute.attributeType = .dateAttributeType
        createdAtAttribute.isOptional = false

        let returnDateAttribute = NSAttributeDescription()
        returnDateAttribute.name = "returnDate"
        returnDateAttribute.attributeType = .dateAttributeType
        returnDateAttribute.isOptional = true

        let isReturnedAttribute = NSAttributeDescription()
        isReturnedAttribute.name = "isReturned"
        isReturnedAttribute.attributeType = .booleanAttributeType
        isReturnedAttribute.isOptional = false

        entity.properties = [
            idAttribute,
            titleAttribute,
            detailAttribute,
            createdAtAttribute,
            returnDateAttribute,
            isReturnedAttribute
        ]
        model.entities = [entity]
        return model
    }

    private static func defaultStoreURL() -> URL {
        let fileManager = FileManager.default
        let baseURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let appURL = baseURL.appendingPathComponent("ReturnTracker", isDirectory: true)
        if !fileManager.fileExists(atPath: appURL.path) {
            try? fileManager.createDirectory(at: appURL, withIntermediateDirectories: true)
        }
        return appURL.appendingPathComponent("ReturnTracker.sqlite")
    }
}
