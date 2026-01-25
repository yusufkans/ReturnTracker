//
//  DefaultCreateReturnItemUseCase.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 23.01.2026.
//

import Foundation

struct DefaultCreateReturnItemUseCase: CreateReturnItemUseCase {
    private let repository: ReturnItemRepository

    init(repository: ReturnItemRepository) {
        self.repository = repository
    }

    func execute(request: CreateReturnItemRequest) throws {
        let item = ReturnItem(
            title: request.title,
            detail: request.detail,
            createdAt: Date(),
            returnDate: request.returnDate,
            isReturned: false
        )
        try repository.save(item)
    }
}
