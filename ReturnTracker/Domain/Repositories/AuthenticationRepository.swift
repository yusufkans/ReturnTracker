//
//  AuthenticationRepository.swift
//  ReturnTracker
//
//  Created by Codex on 27.03.2026.
//

import Foundation

protocol AuthenticationRepository {
    func signIn(email: String, password: String) async throws -> UserSession
}
