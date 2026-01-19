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
        case .active:
            return AnyView(NavigationStack { ActiveRootView() })
        case .archive:
            return AnyView(NavigationStack { ArchiveRootView() })
        case .new:
            return AnyView(NavigationStack { NewRootView() })
        case .settings:
            return AnyView(NavigationStack { SettingsRootView() })
        }
    }
}
