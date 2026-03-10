//
//  AdaptiveBottomSheetModifier.swift
//  ReturnTracker
//
//  Created by Codex on 10.03.2026.
//

import SwiftUI

private struct AdaptiveBottomSheetContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct AdaptiveBottomSheetIntrinsicHeightReader: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: AdaptiveBottomSheetContentHeightKey.self,
                        value: proxy.size.height
                    )
                }
            )
    }
}

private struct AdaptiveBottomSheetModifier: ViewModifier {
    @State private var measuredHeight: CGFloat = 0

    private let minHeight: CGFloat
    private let maxHeightRatio: CGFloat
    private let topInset: CGFloat

    init(
        minHeight: CGFloat,
        maxHeightRatio: CGFloat,
        topInset: CGFloat
    ) {
        self.minHeight = minHeight
        self.maxHeightRatio = maxHeightRatio
        self.topInset = topInset
    }

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(AdaptiveBottomSheetContentHeightKey.self) { newHeight in
                guard abs(newHeight - measuredHeight) > 1 else { return }
                measuredHeight = newHeight
            }
            .presentationDetents([.height(resolvedDetentHeight)])
            .presentationDragIndicator(.visible)
    }

    private var resolvedDetentHeight: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let maximumHeight = max(screenHeight * maxHeightRatio, minHeight)
        let minimumHeight = max(minHeight, 1)
        let candidateHeight = measuredHeight + topInset

        return min(max(candidateHeight, minimumHeight), maximumHeight)
    }
}

extension View {
    /// Reports the intrinsic height of a sheet content container (e.g. the VStack inside a ScrollView).
    func adaptiveBottomSheetContentHeightSource() -> some View {
        modifier(AdaptiveBottomSheetIntrinsicHeightReader())
    }

    /// Makes sheet presentation height track measured intrinsic content size.
    /// Apply `adaptiveBottomSheetContentHeightSource()` to an inner non-scrolling container.
    func adaptiveBottomSheet(
        minHeight: CGFloat = 220,
        maxHeightRatio: CGFloat = 0.9,
        topInset: CGFloat = 24
    ) -> some View {
        modifier(
            AdaptiveBottomSheetModifier(
                minHeight: minHeight,
                maxHeightRatio: maxHeightRatio,
                topInset: topInset
            )
        )
    }
}
