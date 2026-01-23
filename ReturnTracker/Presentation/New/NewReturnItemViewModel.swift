//
//  NewReturnItemViewModel.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 23.01.2026.
//

import Combine
import Foundation

struct AlertState: Identifiable {
    let id = UUID()
    let title: String
    let message: String?
}

@MainActor
final class NewReturnItemViewModel: ObservableObject {
    @Published var itemName = ""
    @Published var storeName = ""
    @Published var selectedPurchaseDate: Date?
    @Published var reminderSevenDaysBefore = true
    @Published var reminderTwoDaysBefore = true
    @Published var reminderLastDay = true
    @Published var alert: AlertState?

    private let createUseCase: CreateReturnItemUseCase

    init(createUseCase: CreateReturnItemUseCase) {
        self.createUseCase = createUseCase
    }

    var purchaseDateText: String {
        guard let selectedPurchaseDate else {
            return "Select date"
        }

        return selectedPurchaseDate.formatted(date: .abbreviated, time: .omitted)
    }

    func save() {
        let trimmedItemName = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedItemName.isEmpty else {
            alert = AlertState(title: "Missing item name", message: "Please add an item name before saving.")
            return
        }

        let trimmedStoreName = storeName.trimmingCharacters(in: .whitespacesAndNewlines)
        let detail = trimmedStoreName.isEmpty ? nil : trimmedStoreName

        let request = CreateReturnItemRequest(
            title: trimmedItemName,
            detail: detail,
            returnDate: selectedPurchaseDate
        )

        do {
            try createUseCase.execute(request: request)
            resetForm()
            alert = AlertState(title: "Saved", message: "Item has been added to your returns.")
        } catch {
            alert = AlertState(title: "Save failed", message: error.localizedDescription)
        }
    }

    private func resetForm() {
        itemName = ""
        storeName = ""
        selectedPurchaseDate = nil
        reminderSevenDaysBefore = true
        reminderTwoDaysBefore = true
        reminderLastDay = true
    }
}
