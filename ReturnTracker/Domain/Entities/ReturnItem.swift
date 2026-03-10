//
//  ReturnItem.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 23.01.2026.
//

import Foundation

struct ReturnItem: Identifiable, Equatable {
    let id: UUID
    var title: String
    var detail: String?
    var createdAt: Date
    var returnDate: Date?
    var isReturned: Bool
    var isArchived: Bool

    init(
        id: UUID = UUID(),
        title: String,
        detail: String? = nil,
        createdAt: Date = Date(),
        returnDate: Date? = nil,
        isReturned: Bool = false,
        isArchived: Bool = false
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.createdAt = createdAt
        self.returnDate = returnDate
        self.isReturned = isReturned
        self.isArchived = isArchived
    }
}
