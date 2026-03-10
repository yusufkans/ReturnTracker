//
//  SettingsRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import Foundation
import SwiftUI

struct SettingsRootView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "gearshape.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(L10n.Settings.title)
                .font(.headline)
        }
        .padding()
        .navigationTitle(L10n.Settings.title)
    }
}

#Preview {
    NavigationStack {
        SettingsRootView()
    }
}
