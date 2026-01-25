//
//  AppAnimation.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 06.02.2026.
//

import SwiftUI

enum AppAnimation {
    static let action = Animation.spring(response: 0.3, dampingFraction: 0.85)
    static let toastFade = Animation.easeInOut(duration: 0.2)
    static let listItemTransition = AnyTransition.asymmetric(
        insertion: .opacity.combined(with: .scale(scale: 0.98)),
        removal: .opacity.combined(with: .move(edge: .trailing))
    )
    static let toastTransition = AnyTransition.move(edge: .top).combined(with: .opacity)
}
