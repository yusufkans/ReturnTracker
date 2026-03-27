//
//  DefaultSignInUseCase.swift
//  ReturnTracker
//
//  Created by Codex on 27.03.2026.
//

import Foundation

struct DefaultSignInUseCase: SignInUseCase {
    private let repository: AuthenticationRepository

    init(repository: AuthenticationRepository) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> UserSession {
        try await repository.signIn(email: email, password: password)
    }
}
