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

    private var displayedItems: [ReturnItemCellViewModel] {
        viewModel.items(for: segment)
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
                ForEach(displayedItems) { item in
                    ProductMainCell(
                        viewModel: item,
                        onCellTap: {
                            selectedItem = item.item
                        },
                        onPrimaryTap: {
                            withAnimation(AppAnimation.action) {
                                viewModel.markReturned(for: item.item)
                            }
                            viewModel.showToast(message: "Marked as returned")
                        },
                        onSecondaryTap: {
                            let message = item.item.isReturned ? "Unarchived" : "Archived"
                            withAnimation(AppAnimation.action) {
                                viewModel.toggleArchive(for: item.item)
                            }
                            viewModel.showToast(message: message)
                        }
                    )
                    .transition(AppAnimation.listItemTransition)
                }
            }
            .padding()
        }
        .navigationTitle("Returns")
        .navigationBarTitleDisplayMode(.automatic)
        .backgroundStyle(Color(.systemGroupedBackground))
        .overlay(alignment: .top) {
            if let toast = viewModel.toast {
                ToastView(message: toast.message)
                    .transition(AppAnimation.toastTransition)
                    .padding(.top, 8)
            }
        }
        .animation(AppAnimation.toastFade, value: viewModel.toast?.id)
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
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationStack {
        ReturnsRootView(viewModel: .preview())
    }
}
