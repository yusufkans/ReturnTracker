//
//  SignInUseCase.swift
//  ReturnTracker
//
//  Created by Codex on 27.03.2026.
//

import Foundation

protocol SignInUseCase {
    func execute(email: String, password: String) async throws -> UserSession
}
