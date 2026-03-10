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
            return NSLocalizedString("tab.returns", comment: "Returns tab title")
        case .new:
            return NSLocalizedString("tab.new", comment: "New tab title")
        case .settings:
            return NSLocalizedString("tab.settings", comment: "Settings tab title")
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
