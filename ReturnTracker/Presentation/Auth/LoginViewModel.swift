//
//  LoginViewModel.swift
//  ReturnTracker
//
//  Created by Codex on 27.03.2026.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let signInUseCase: SignInUseCase
    private let onAuthenticated: (UserSession) -> Void

    init(
        signInUseCase: SignInUseCase,
        onAuthenticated: @escaping (UserSession) -> Void
    ) {
        self.signInUseCase = signInUseCase
        self.onAuthenticated = onAuthenticated
    }

    var canSubmit: Bool {
        !isLoading && !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.isEmpty
    }

    func login() async {
        guard canSubmit else { return }
        isLoading = true
        errorMessage = nil

        do {
            let session = try await signInUseCase.execute(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            onAuthenticated(session)
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Beklenmeyen bir hata oluştu."
        }

        isLoading = false
    }
}
