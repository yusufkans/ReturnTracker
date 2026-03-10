//
//  ReturnsRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import Foundation
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
            Picker(L10n.Returns.segmentPicker, selection: $segment) {
                Text(L10n.Returns.segmentActive)
                    .tag(ReturnsPageSegments.active)
                Text(L10n.Returns.segmentArchive)
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
                            viewModel.showToast(message: L10n.Toast.markedAsReturned)
                        },
                        onSecondaryTap: {
                            let message = item.item.isReturned
                                ? L10n.Toast.unarchived
                                : L10n.Toast.archived
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
        .navigationTitle(L10n.Returns.title)
        .navigationBarTitleDisplayMode(.automatic)
        .backgroundStyle(Color(.systemGroupedBackground))
        .overlay(alignment: .bottom) {
            if let toast = viewModel.toast {
                ToastView(message: toast.message)
                    .transition(AppAnimation.toastTransition)
                    .padding(.bottom, 32)
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
            .adaptiveBottomSheet()
        }
    }
}

#Preview {
    NavigationStack {
        ReturnsRootView(viewModel: .preview())
    }
}
