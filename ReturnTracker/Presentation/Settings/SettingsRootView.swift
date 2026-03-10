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
            Text(NSLocalizedString("settings.title", comment: "Settings screen title"))
                .font(.headline)
        }
        .padding()
        .navigationTitle(NSLocalizedString("settings.title", comment: "Settings navigation title"))
    }
}

#Preview {
    NavigationStack {
        SettingsRootView()
    }
}
