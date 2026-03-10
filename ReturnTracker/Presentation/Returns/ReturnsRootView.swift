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
            Picker(NSLocalizedString("returns.segment.picker", comment: "Returns segment picker accessibility title"), selection: $segment) {
                Text(NSLocalizedString("returns.segment.active", comment: "Active segment title"))
                    .tag(ReturnsPageSegments.active)
                Text(NSLocalizedString("returns.segment.archive", comment: "Archive segment title"))
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
                            viewModel.showToast(message: NSLocalizedString("toast.marked_as_returned", comment: "Toast for mark returned action"))
                        },
                        onSecondaryTap: {
                            let message = item.item.isReturned
                                ? NSLocalizedString("toast.unarchived", comment: "Toast for unarchive action")
                                : NSLocalizedString("toast.archived", comment: "Toast for archive action")
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
        .navigationTitle(NSLocalizedString("returns.title", comment: "Returns screen title"))
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
