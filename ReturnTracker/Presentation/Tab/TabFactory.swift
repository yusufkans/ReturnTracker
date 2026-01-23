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
    private let container: AppDependencyContainer

    init(container: AppDependencyContainer = AppDependencyContainer()) {
        self.container = container
    }

    func makeView(for tab: AppTab) -> AnyView {
        switch tab {
        case .products:
            return AnyView(NavigationStack { ReturnsRootView() })
        case .new:
            let viewModel = NewReturnItemViewModel(createUseCase: container.createReturnItemUseCase)
            return AnyView(NavigationStack { NewRootView(viewModel: viewModel) })
        case .settings:
            return AnyView(NavigationStack { SettingsRootView() })
        }
    }
}
