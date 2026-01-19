//
//  SettingsRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

struct SettingsRootView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "gearshape.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Settings")
                .font(.headline)
        }
        .padding()
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsRootView()
    }
}
