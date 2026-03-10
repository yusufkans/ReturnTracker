//
//  ReturnItemStatusPolicy.swift
//  ReturnTracker
//
//  Created by Codex on 10.03.2026.
//

import Foundation

protocol ReturnItemStatusEvaluating {
    func isReturnWindowExpired(for item: ReturnItem, now: Date) -> Bool
    func canMarkReturned(_ item: ReturnItem, now: Date) -> Bool
    func canUnarchive(_ item: ReturnItem, now: Date) -> Bool
    func markReturned(_ item: ReturnItem) -> ReturnItem
    func archive(_ item: ReturnItem) -> ReturnItem
    func unarchive(_ item: ReturnItem) -> ReturnItem
}

struct ReturnItemStatusPolicy: ReturnItemStatusEvaluating {
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func isReturnWindowExpired(for item: ReturnItem, now: Date = Date()) -> Bool {
        guard let returnDate = item.returnDate else {
            return false
        }
        let todayStart = calendar.startOfDay(for: now)
        return returnDate < todayStart
    }

    func canMarkReturned(_ item: ReturnItem, now: Date = Date()) -> Bool {
        guard item.isReturned == false else {
            return false
        }
        if item.isArchived {
            return isReturnWindowExpired(for: item, now: now) == false
        }
        return true
    }

    func canUnarchive(_ item: ReturnItem, now: Date = Date()) -> Bool {
        guard item.isArchived else {
            return false
        }
        return isReturnWindowExpired(for: item, now: now) == false
    }

    func markReturned(_ item: ReturnItem) -> ReturnItem {
        var updatedItem = item
        updatedItem.isReturned = true
        updatedItem.isArchived = true
        return updatedItem
    }

    func archive(_ item: ReturnItem) -> ReturnItem {
        var updatedItem = item
        updatedItem.isArchived = true
        return updatedItem
    }

    func unarchive(_ item: ReturnItem) -> ReturnItem {
        var updatedItem = item
        updatedItem.isArchived = false
        updatedItem.isReturned = false
        return updatedItem
    }
}
