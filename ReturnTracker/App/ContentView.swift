//
//  ContentView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

struct ContentView: View {
    private let tabFactory: TabFactory
    private let signInUseCase: SignInUseCase
    @StateObject private var sessionViewModel = AppSessionViewModel()

    init(
        tabFactory: TabFactory = DefaultTabFactory(),
        signInUseCase: SignInUseCase = DefaultSignInUseCase(repository: MockAuthenticationRepository())
    ) {
        self.tabFactory = tabFactory
        self.signInUseCase = signInUseCase
    }

    var body: some View {
        Group {
            if sessionViewModel.isAuthenticated {
                TabContainerView(tabFactory: tabFactory)
            } else {
                LoginView(
                    viewModel: LoginViewModel(
                        signInUseCase: signInUseCase,
                        onAuthenticated: { session in
                            sessionViewModel.start(session: session)
                        }
                    )
                )
            }
        }
        .animation(.spring(response: 0.38, dampingFraction: 0.88), value: sessionViewModel.isAuthenticated)
    }
}

#Preview {
    ContentView()
}
