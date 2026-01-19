//
//  NewRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

struct NewRootView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Create Return")
                .font(.headline)
        }
        .padding()
        .navigationTitle("New")
    }
}

#Preview {
    NavigationStack {
        NewRootView()
    }
}
