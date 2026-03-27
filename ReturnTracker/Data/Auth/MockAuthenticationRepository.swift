//
//  MockAuthenticationRepository.swift
//  ReturnTracker
//
//  Created by Codex on 27.03.2026.
//

import Foundation

enum AuthenticationError: LocalizedError {
    case invalidCredentials
    case invalidEmailFormat

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "E-posta veya şifre hatalı."
        case .invalidEmailFormat:
            return "Geçerli bir e-posta adresi gir."
        }
    }
}

struct MockAuthenticationRepository: AuthenticationRepository {
    func signIn(email: String, password: String) async throws -> UserSession {
        try await Task.sleep(for: .milliseconds(700))

        guard email.contains("@"), email.contains(".") else {
            throw AuthenticationError.invalidEmailFormat
        }

        guard password.count >= 6 else {
            throw AuthenticationError.invalidCredentials
        }

        return UserSession(email: email)
    }
}
