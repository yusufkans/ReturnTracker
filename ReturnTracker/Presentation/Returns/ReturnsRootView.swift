//
//  ReturnsRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import CoreData
import SwiftUI

enum ReturnsPageSegments: Hashable {
    case active
    case archive
}

struct ReturnsRootView: View {
    @State var segment: ReturnsPageSegments = .active
    @StateObject private var viewModel: ReturnsRootViewModel

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
                        onCellTap: {},
                        onPrimaryTap: {},
                        onSecondaryTap: {}
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Returns")
        .navigationBarTitleDisplayMode(.automatic)
        .task {
            viewModel.load()
        }
    }
}

#Preview {
    let stack = try! CoreDataStack(storeType: NSInMemoryStoreType)
    let repository = CoreDataReturnItemRepository(store: stack)
    let viewModel = ReturnsRootViewModel(repository: repository)
    NavigationStack {
        ReturnsRootView(viewModel: viewModel)
    }
}
