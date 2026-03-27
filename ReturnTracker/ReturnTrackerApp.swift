//
//  ReturnTrackerApp.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ReturnTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    private let container = AppDependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(
                tabFactory: DefaultTabFactory(container: container),
                signInUseCase: container.signInUseCase
            )
        }
    }
}
