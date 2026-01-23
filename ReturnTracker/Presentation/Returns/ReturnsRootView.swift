//
//  ReturnsRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

enum ReturnsPageSegments: Hashable {
    case active
    case archive
}

struct ReturnsRootView: View {
    @State var segment: ReturnsPageSegments = .active
    @StateObject private var viewModel: ReturnsRootViewModel
    @State private var selectedItem: ReturnItem?

    init(viewModel: ReturnsRootViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            Picker("What is your favorite color?", selection: $segment) {
                Text("Active")
                    .tag(ReturnsPageSegments.active)
                Text("Archive")
                    .tag(ReturnsPageSegments.archive)
            }
            .pickerStyle(.segmented)
            .padding()
            
            LazyVStack(spacing: 16) {
                ForEach(viewModel.items(for: segment)) { item in
                    ProductMainCell(
                        viewModel: item,
                        onCellTap: {
                            selectedItem = item.item
                        },
                        onPrimaryTap: {},
                        onSecondaryTap: {}
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Returns")
        .navigationBarTitleDisplayMode(.automatic)
        .backgroundStyle(Color(.systemGroupedBackground))
        .task {
            viewModel.load()
        }
        .sheet(item: $selectedItem) { item in
            ReturnDetailsView(
                viewModel: viewModel.makeDetailsViewModel(for: item),
                onUpdate: {
                    viewModel.load()
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationStack {
        ReturnsRootView(viewModel: .preview())
    }
}
