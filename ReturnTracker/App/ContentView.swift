//
//  ContentView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

struct ContentView: View {
    private let tabFactory: TabFactory

    init(tabFactory: TabFactory = DefaultTabFactory()) {
        self.tabFactory = tabFactory
    }

    var body: some View {
        TabContainerView(tabFactory: tabFactory)
    }
}

#Preview {
    ContentView()
}
