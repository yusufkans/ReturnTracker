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
    @State private var toast: ToastState?
    @State private var toastTask: Task<Void, Never>?

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
                            showToast(message: "Marked as returned")
                        },
                        onSecondaryTap: {
                            let message = item.item.isReturned ? "Unarchived" : "Archived"
                            withAnimation(AppAnimation.action) {
                                viewModel.toggleArchive(for: item.item)
                            }
                            showToast(message: message)
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
            if let toast {
                ToastView(message: toast.message)
                    .transition(AppAnimation.toastTransition)
                    .padding(.top, 8)
            }
        }
        .animation(AppAnimation.action, value: displayedItems.map(\.id))
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

    private func showToast(message: String) {
        toastTask?.cancel()
        withAnimation(AppAnimation.toastFade) {
            toast = ToastState(message: message)
        }
        toastTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            guard !Task.isCancelled else { return }
            withAnimation(AppAnimation.toastFade) {
                toast = nil
            }
        }
    }
}

#Preview {
    NavigationStack {
        ReturnsRootView(viewModel: .preview())
    }
}
