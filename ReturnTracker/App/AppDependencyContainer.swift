//
//  AppDependencyContainer.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import Foundation

final class AppDependencyContainer {
    let coreDataStack: CoreDataStoring
    let returnItemRepository: ReturnItemRepository
    let createReturnItemUseCase: CreateReturnItemUseCase
    let authenticationRepository: AuthenticationRepository
    let signInUseCase: SignInUseCase

    init() {
        do {
            let stack = try CoreDataStack()
            coreDataStack = stack
            let repository = CoreDataReturnItemRepository(store: stack)
            returnItemRepository = repository
            createReturnItemUseCase = DefaultCreateReturnItemUseCase(repository: repository)
            let authenticationRepository = MockAuthenticationRepository()
            self.authenticationRepository = authenticationRepository
            signInUseCase = DefaultSignInUseCase(repository: authenticationRepository)
        } catch {
            fatalError("Failed to initialize Core Data stack: \(error)")
        }
    }
}
