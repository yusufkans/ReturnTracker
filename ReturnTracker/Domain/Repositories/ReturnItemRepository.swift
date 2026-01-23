//
//  ReturnItemRepository.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 23.01.2026.
//

import Foundation

protocol ReturnItemRepository {
    func fetchAll() throws -> [ReturnItem]
    func fetchActive() throws -> [ReturnItem]
    func save(_ item: ReturnItem) throws
    func delete(id: UUID) throws
}
