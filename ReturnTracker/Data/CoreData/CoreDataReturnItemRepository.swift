//
//  CoreDataReturnItemRepository.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 23.01.2026.
//

import CoreData
import Foundation

@MainActor
final class CoreDataReturnItemRepository: ReturnItemRepository {
    private let store: CoreDataStoring

    init(store: CoreDataStoring) {
        self.store = store
    }

    func fetchAll() throws -> [ReturnItem] {
        let context = store.mainContext
        return try performAndWait(context) {
            let request = ManagedReturnItem.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            let managedItems = try context.fetch(request)
            return managedItems.map(ReturnItemMapper.mapToDomain)
        }
    }

    func fetchActive() throws -> [ReturnItem] {
        let context = store.mainContext
        return try performAndWait(context) {
            let request = ManagedReturnItem.fetchRequest()
            request.predicate = NSPredicate(format: "isArchived == NO")
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            let managedItems = try context.fetch(request)
            return managedItems.map(ReturnItemMapper.mapToDomain)
        }
    }

    func save(_ item: ReturnItem) throws {
        let context = store.mainContext
        try performAndWait(context) {
            let managedItem = try fetchOrCreate(id: item.id, in: context)
            ReturnItemMapper.update(managedItem, from: item)
            try store.save(context: context)
        }
    }

    func delete(id: UUID) throws {
        let context = store.mainContext
        try performAndWait(context) {
            guard let managedItem = try fetchManaged(id: id, in: context) else { return }
            context.delete(managedItem)
            try store.save(context: context)
        }
    }

    private func fetchOrCreate(id: UUID, in context: NSManagedObjectContext) throws -> ManagedReturnItem {
        if let existing = try fetchManaged(id: id, in: context) {
            return existing
        }
        let managedItem = ManagedReturnItem(context: context)
        managedItem.id = id
        return managedItem
    }

    private func fetchManaged(id: UUID, in context: NSManagedObjectContext) throws -> ManagedReturnItem? {
        let request = ManagedReturnItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private func performAndWait<T>(
        _ context: NSManagedObjectContext,
        operation: () throws -> T
    ) throws -> T {
        var result: T?
        var caughtError: Error?
        context.performAndWait {
            do {
                result = try operation()
            } catch {
                caughtError = error
            }
        }
        if let caughtError {
            throw caughtError
        }
        guard let result else {
            throw CoreDataRepositoryError.unknown
        }
        return result
    }
}

enum CoreDataRepositoryError: Error {
    case unknown
}
