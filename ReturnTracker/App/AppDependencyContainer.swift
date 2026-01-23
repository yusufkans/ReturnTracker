import Foundation

final class AppDependencyContainer {
    let coreDataStack: CoreDataStoring
    let returnItemRepository: ReturnItemRepository
    let createReturnItemUseCase: CreateReturnItemUseCase

    init() {
        do {
            let stack = try CoreDataStack()
            coreDataStack = stack
            let repository = CoreDataReturnItemRepository(store: stack)
            returnItemRepository = repository
            createReturnItemUseCase = DefaultCreateReturnItemUseCase(repository: repository)
        } catch {
            fatalError("Failed to initialize Core Data stack: \(error)")
        }
    }
}
