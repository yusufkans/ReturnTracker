//
//  ActiveRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

struct ActiveRootView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Active Returns")
                .font(.headline)
        }
        .padding()
        .navigationTitle("Active")
    }
}

#Preview {
    NavigationStack {
        ActiveRootView()
    }
}
