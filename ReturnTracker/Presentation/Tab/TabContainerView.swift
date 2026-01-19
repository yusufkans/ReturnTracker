//
//  TabContainerView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

struct TabContainerView: View {
    private let tabFactory: TabFactory
    @State private var selectedTab: AppTab = .active

    init(tabFactory: TabFactory) {
        self.tabFactory = tabFactory
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases) { tab in
                tabFactory
                    .makeView(for: tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImageName)
                    }
                    .tag(tab)
            }
        }
    }
}

#Preview {
    TabContainerView(tabFactory: DefaultTabFactory())
}
