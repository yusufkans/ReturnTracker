//
//  ReturnTrackerApp.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

@main
struct ReturnTrackerApp: App {
    private let container = AppDependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(tabFactory: DefaultTabFactory(container: container))
        }
    }
}
