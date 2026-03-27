//
//  LoginView.swift
//  ReturnTracker
//
//  Created by Codex on 27.03.2026.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(viewModel: @autoclosure @escaping () -> LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        ZStack {
            backgroundGradient

            VStack(spacing: 28) {
                header
                formCard
                signUpButton
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 22)
            .padding(.top, 40)
            .padding(.bottom, 16)
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color("AuthBackgroundStart"),
                Color("AuthBackgroundMiddle"),
                Color("AuthBackgroundEnd")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(Color("AuthGlow"))
                .blur(radius: 35)
                .frame(width: 220, height: 220)
                .offset(x: 80, y: -40)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L10n.Auth.welcomeTitle)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(L10n.Auth.welcomeMessage)
                .font(.subheadline)
                .foregroundStyle(Color("AuthSubtitleText"))
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var formCard: some View {
        VStack(spacing: 18) {
            credentialField(
                title: L10n.Auth.emailLabel,
                systemImage: "envelope.fill",
                prompt: L10n.Auth.emailPlaceholder,
                text: $viewModel.email
            )
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled(true)

            credentialField(
                title: L10n.Auth.passwordLabel,
                systemImage: "lock.fill",
                prompt: L10n.Auth.passwordPlaceholder,
                text: $viewModel.password,
                isSecure: true
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity)
            }

            Button {
                Task { await viewModel.login() }
            } label: {
                HStack(spacing: 10) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    Text(viewModel.isLoading ? L10n.Auth.signingIn : L10n.Auth.signIn)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .foregroundStyle(.white)
                .background(Color("AuthPrimaryButton"), in: Capsule())
            }
            .disabled(!viewModel.canSubmit)
            .opacity(viewModel.canSubmit ? 1 : 0.65)

            socialSection
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color("AuthCardFill"))
                .overlay {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color("AuthCardStroke"), lineWidth: 1)
                }
                .shadow(color: Color("AuthCardShadow"), radius: 18, y: 8)
        )
    }

    private var socialSection: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                Rectangle()
                    .fill(.gray.opacity(0.25))
                    .frame(height: 1)
                Text(L10n.Auth.orContinueWith)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.secondary)
                Rectangle()
                    .fill(.gray.opacity(0.25))
                    .frame(height: 1)
            }

            socialButton(
                title: L10n.Auth.signInWithApple,
                icon: "apple.logo",
                background: .black,
                foreground: .white
            ) {
                viewModel.socialSignInTapped(.apple)
            }

            socialButton(
                title: L10n.Auth.signInWithGoogle,
                icon: "globe",
                background: .white,
                foreground: .black
            ) {
                viewModel.socialSignInTapped(.google)
            }
            .overlay {
                Capsule()
                    .stroke(.gray.opacity(0.25), lineWidth: 1)
            }
        }
    }

    private func credentialField(
        title: String,
        systemImage: String,
        prompt: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color("AuthFieldLabel"))

            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .foregroundStyle(.secondary)
                Group {
                    if isSecure {
                        SecureField(prompt, text: text)
                    } else {
                        TextField(prompt, text: text)
                    }
                }
                .font(.subheadline)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(Color("AuthFieldFill"), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    private func socialButton(
        title: String,
        icon: String,
        background: Color,
        foreground: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.headline)
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(foreground)
            .background(background, in: Capsule())
        }
    }

    private var signUpButton: some View {
        Button {
            viewModel.signUpTapped()
        } label: {
            Text(L10n.Auth.signUp)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.white.opacity(0.95))
                .underline()
                .padding(.top, 6)
        }
    }
}

#Preview {
    let container = AppDependencyContainer()
    LoginView(
        viewModel: LoginViewModel(
            signInUseCase: container.signInUseCase,
            onAuthenticated: { _ in }
        )
    )
}
