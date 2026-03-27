//
//  L10n.swift
//  ReturnTracker
//
//  Created by Codex on 10.03.2026.
//

import Foundation

enum L10n {
    private static func text(_ key: String, _ comment: String) -> String {
        NSLocalizedString(key, comment: comment)
    }

    enum Tab {
        static var returnsTitle: String { L10n.text("tab.returns", "Returns tab title") }
        static var newTitle: String { L10n.text("tab.new", "New tab title") }
        static var settingsTitle: String { L10n.text("tab.settings", "Settings tab title") }
    }

    enum Settings {
        static var title: String { L10n.text("settings.title", "Settings title") }
    }

    enum Common {
        static var ok: String { L10n.text("common.ok", "OK button title") }
        static var cancel: String { L10n.text("common.cancel", "Cancel button title") }
        static var save: String { L10n.text("common.save", "Save button title") }
        static var selectDate: String { L10n.text("common.select_date", "Date selection placeholder") }
        static var dash: String { L10n.text("common.dash", "Placeholder dash") }
    }

    enum New {
        static var quickAdd: String { L10n.text("new.quick_add", "Quick add") }
        static var manualAdd: String { L10n.text("new.manual_add", "Manual add") }
        static var reminders: String { L10n.text("new.reminders", "Reminders section title") }
        static var itemName: String { L10n.text("new.item_name", "Item name label") }
        static var itemNamePlaceholder: String { L10n.text("new.item_name.placeholder", "Item name placeholder") }
        static var storeName: String { L10n.text("new.store_name", "Store name label") }
        static var storeNamePlaceholder: String { L10n.text("new.store_name.placeholder", "Store name placeholder") }
        static var purchaseDate: String { L10n.text("new.purchase_date", "Purchase date label") }
        static var saveItem: String { L10n.text("new.action.save_item", "Save item action") }
        static var uploadTitle: String { L10n.text("new.upload.title", "Upload card title") }
        static var uploadSubtitleShort: String { L10n.text("new.upload.subtitle.short", "Upload card subtitle short") }
        static var uploadSubtitleLong: String { L10n.text("new.upload.subtitle.long", "Upload card subtitle long") }
        static var reminderSevenDays: String { L10n.text("new.reminder.seven_days", "Seven days reminder") }
        static var reminderTwoDays: String { L10n.text("new.reminder.two_days", "Two days reminder") }
        static var reminderLastDay: String { L10n.text("new.reminder.last_day", "Last day reminder") }
    }

    enum Alert {
        static var missingItemNameTitle: String { L10n.text("alert.missing_item_name.title", "Missing item name title") }
        static var missingItemNameMessage: String { L10n.text("alert.missing_item_name.message", "Missing item name message") }
        static var savedTitle: String { L10n.text("alert.saved.title", "Saved title") }
        static var savedNewItemMessage: String { L10n.text("alert.saved.new_item.message", "Saved new item message") }
        static var savedUpdatedItemMessage: String { L10n.text("alert.saved.updated_item.message", "Saved updated item message") }
        static var saveFailedTitle: String { L10n.text("alert.save_failed.title", "Save failed title") }
    }

    enum Returns {
        static var title: String { L10n.text("returns.title", "Returns title") }
        static var searchPlaceholder: String { L10n.text("returns.search.placeholder", "Returns search placeholder") }
        static var segmentPicker: String { L10n.text("returns.segment.picker", "Returns segment picker title") }
        static var segmentActive: String { L10n.text("returns.segment.active", "Active segment") }
        static var segmentArchive: String { L10n.text("returns.segment.archive", "Archive segment") }
        static var actionReturned: String { L10n.text("returns.action.returned", "Returned action") }
        static var actionMarkReturned: String { L10n.text("returns.action.mark_returned", "Mark returned action") }
        static var actionArchive: String { L10n.text("returns.action.archive", "Archive action") }
        static var actionUnarchive: String { L10n.text("returns.action.unarchive", "Unarchive action") }
        static var statusReturned: String { L10n.text("returns.status.returned", "Returned status") }
        static var statusActive: String { L10n.text("returns.status.active", "Active status") }
        static var dateTBD: String { L10n.text("returns.date.tbd", "Return date TBD") }
        static var sortMenuTitle: String { L10n.text("returns.sort.menu.title", "Sort menu title") }
        static var sortNearestReturnDate: String { L10n.text("returns.sort.return_date.nearest", "Sort by nearest return date") }
        static var sortFarthestReturnDate: String { L10n.text("returns.sort.return_date.farthest", "Sort by farthest return date") }
        static var sortNewestAdded: String { L10n.text("returns.sort.created_at.newest", "Sort by newest added date") }
        static var sortOldestAdded: String { L10n.text("returns.sort.created_at.oldest", "Sort by oldest added date") }

        static func lastDay(_ date: String) -> String {
            let format = L10n.text("returns.last_day.format", "Last day format")
            return String(format: format, locale: Locale.current, date)
        }

        static func daysBadge(_ dayCount: Int) -> String {
            let format = L10n.text("returns.badge.days.format", "Days badge format")
            return String(format: format, locale: Locale.current, dayCount)
        }
    }

    enum Toast {
        static var markedAsReturned: String { L10n.text("toast.marked_as_returned", "Marked as returned toast") }
        static var archived: String { L10n.text("toast.archived", "Archived toast") }
        static var unarchived: String { L10n.text("toast.unarchived", "Unarchived toast") }
    }

    enum Details {
        static var overview: String { L10n.text("details.overview", "Overview section") }
        static var created: String { L10n.text("details.created", "Created label") }
        static var status: String { L10n.text("details.status", "Status label") }
        static var sectionTitle: String { L10n.text("details.section.title", "Details section") }
        static var returnDate: String { L10n.text("details.return_date", "Return date label") }
        static var saveChanges: String { L10n.text("details.action.save_changes", "Save changes action") }
        static var actions: String { L10n.text("details.actions", "Actions section") }
    }

    enum Preview {
        static var productTitle: String { L10n.text("preview.product_title", "Preview product title") }
        static var productSubtitle: String { L10n.text("preview.product_subtitle", "Preview product subtitle") }
        static var productBadge: String { L10n.text("preview.product_badge", "Preview product badge") }
        static var itemName: String { L10n.text("preview.item_name", "Preview item name") }
        static var storeName: String { L10n.text("preview.store_name", "Preview store name") }
    }
}
