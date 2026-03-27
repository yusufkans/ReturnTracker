//
//  ReturnsRootView.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import Foundation
import SwiftUI

struct ReturnsRootView: View {
    @State private var segment: ReturnItemStatusSegment = .active
    @StateObject private var viewModel: ReturnsRootViewModel
    @State private var selectedItem: ReturnItem?
    @State private var searchText: String = ""
    @State private var sortOption: ReturnsSortOption = .returnDateNearest

    init(viewModel: ReturnsRootViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private var displayedItems: [ReturnItemCellViewModel] {
        viewModel.items(for: segment, matching: searchText, sortedBy: sortOption)
    }

    private var searchBar: some View {
        SearchTextField(
            placeholder: L10n.Returns.searchPlaceholder,
            text: $searchText,
            leadingAccessory: {
                Image(systemName: "magnifyingglass")
                    .font(.subheadline)
            },
            trailingAccessory: {
                Menu {
                    ForEach(ReturnsSortOption.allCases) { option in
                        Button {
                            sortOption = option
                        } label: {
                            HStack {
                                Text(option.title)
                                if sortOption == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down.circle")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel(L10n.Returns.sortMenuTitle)
                }
            }
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                searchBar

                Picker(L10n.Returns.segmentPicker, selection: $segment) {
                    Text(L10n.Returns.segmentActive)
                        .tag(ReturnItemStatusSegment.active)
                    Text(L10n.Returns.segmentReturned)
                        .tag(ReturnItemStatusSegment.returned)
                }
                .pickerStyle(.segmented)
            }
            .padding([.top, .horizontal])

            LazyVStack(spacing: 16) {
                ForEach(displayedItems) { item in
                    ProductMainCell(
                        viewModel: item,
                        onCellTap: {
                            selectedItem = item.item
                        },
                        isReturned: item.item.isReturned,
                        onMarkReturned: {
                            withAnimation(AppAnimation.action) {
                                viewModel.markReturned(for: item.item)
                            }
                            viewModel.showToast(message: L10n.Toast.markedAsReturned)
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
