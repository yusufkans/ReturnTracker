//
//  ReturnItemMapper.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 23.01.2026.
//

import Foundation

enum ReturnItemMapper {
    static func mapToDomain(_ managed: ManagedReturnItem) -> ReturnItem {
        ReturnItem(
            id: managed.id,
            title: managed.title,
            detail: managed.detail,
            createdAt: managed.createdAt,
            returnDate: managed.returnDate,
            isReturned: managed.isReturned,
            isArchived: managed.isArchived
        )
    }

    static func update(_ managed: ManagedReturnItem, from item: ReturnItem) {
        managed.id = item.id
        managed.title = item.title
        managed.detail = item.detail
        managed.createdAt = item.createdAt
        managed.returnDate = item.returnDate
        managed.isReturned = item.isReturned
        managed.isArchived = item.isArchived
    }
}
