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
                Color(.sRGB, red: 0.11, green: 0.15, blue: 0.28, opacity: 1),
                Color(.sRGB, red: 0.16, green: 0.32, blue: 0.61, opacity: 1),
                Color(.sRGB, red: 0.89, green: 0.93, blue: 1.0, opacity: 1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(.white.opacity(0.2))
                .blur(radius: 35)
                .frame(width: 220, height: 220)
                .offset(x: 80, y: -40)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hoş geldin 👋")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text("ReturnTracker hesabına giriş yap ve iadelerini takip etmeye devam et.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.86))
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var formCard: some View {
        VStack(spacing: 18) {
            credentialField(
                title: "E-posta",
                systemImage: "envelope.fill",
                prompt: "name@company.com",
                text: $viewModel.email
            )
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled(true)

            credentialField(
                title: "Şifre",
                systemImage: "lock.fill",
                prompt: "••••••••",
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
                    Text(viewModel.isLoading ? "Giriş Yapılıyor" : "Giriş Yap")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .foregroundStyle(.white)
                .background(Color.black.opacity(0.82), in: Capsule())
            }
            .disabled(!viewModel.canSubmit)
            .opacity(viewModel.canSubmit ? 1 : 0.65)
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white.opacity(0.78))
                .overlay {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.white.opacity(0.46), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.15), radius: 18, y: 8)
        )
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
                .foregroundStyle(.black.opacity(0.7))

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
            .background(Color.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
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
