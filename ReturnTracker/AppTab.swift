//
//  AppTab.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case active
    case archive
    case new
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .active:
            return "Active"
        case .archive:
            return "Archive"
        case .new:
            return "New"
        case .settings:
            return "Settings"
        }
    }

    var systemImageName: String {
        switch self {
        case .active:
            return "tray.fill"
        case .archive:
            return "archivebox.fill"
        case .new:
            return "plus.circle.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}
