//
//  AppSessionViewModel.swift
//  ReturnTracker
//
//  Created by Codex on 27.03.2026.
//

import Foundation

@MainActor
final class AppSessionViewModel: ObservableObject {
    @Published private(set) var userSession: UserSession?

    var isAuthenticated: Bool {
        userSession != nil
    }

    func start(session: UserSession) {
        userSession = session
    }
}
