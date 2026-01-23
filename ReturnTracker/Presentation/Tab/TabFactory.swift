//
//  TabFactory.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

protocol TabFactory {
    func makeView(for tab: AppTab) -> AnyView
}

struct DefaultTabFactory: TabFactory {
    func makeView(for tab: AppTab) -> AnyView {
        switch tab {
        case .products:
            return AnyView(NavigationStack { ReturnsRootView() })
        case .new:
            return AnyView(NavigationStack { NewRootView() })
        case .settings:
            return AnyView(NavigationStack { SettingsRootView() })
        }
    }
}
