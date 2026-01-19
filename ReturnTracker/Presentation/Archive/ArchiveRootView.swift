//
//  ArchiveRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

struct ArchiveRootView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "archivebox.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Archived Returns")
                .font(.headline)
        }
        .padding()
        .navigationTitle("Archive")
    }
}

#Preview {
    NavigationStack {
        ArchiveRootView()
    }
}
