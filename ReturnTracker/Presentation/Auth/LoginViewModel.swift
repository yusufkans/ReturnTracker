//
//  LoginViewModel.swift
//  ReturnTracker
//
//  Created by Codex on 27.03.2026.
//

import Foundation

enum SocialProvider {
    case apple
    case google
}

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let signInUseCase: SignInUseCase
    private let onAuthenticated: (UserSession) -> Void
    private let onSignUpTap: () -> Void

    init(
        signInUseCase: SignInUseCase,
        onAuthenticated: @escaping (UserSession) -> Void,
        onSignUpTap: @escaping () -> Void = {}
    ) {
        self.signInUseCase = signInUseCase
        self.onAuthenticated = onAuthenticated
        self.onSignUpTap = onSignUpTap
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
            errorMessage = (error as? LocalizedError)?.errorDescription ?? L10n.Auth.unknownError
        }

        isLoading = false
    }

    func socialSignInTapped(_ provider: SocialProvider) {
        let providerName: String
        switch provider {
        case .apple:
            providerName = L10n.Auth.socialProviderApple
        case .google:
            providerName = L10n.Auth.socialProviderGoogle
        }
        errorMessage = L10n.Auth.socialComingSoon(providerName)
    }

    func signUpTapped() {
        onSignUpTap()
    }
}
