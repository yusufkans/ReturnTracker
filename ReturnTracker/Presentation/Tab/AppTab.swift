//
//  AppTab.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import Foundation
import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case products
    case new
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .products:
            return L10n.Tab.returnsTitle
        case .new:
            return L10n.Tab.newTitle
        case .settings:
            return L10n.Tab.settingsTitle
        }
    }

    var systemImageName: String {
        switch self {
        case .products:
            return "tray.fill"
        case .new:
            return "plus.circle.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}
