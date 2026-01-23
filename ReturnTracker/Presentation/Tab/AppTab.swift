//
//  AppTab.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case products
    case new
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .products:
            return "Returns"
        case .new:
            return "New"
        case .settings:
            return "Settings"
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
