import Foundation

struct CreateReturnItemRequest {
    let title: String
    let detail: String?
    let returnDate: Date?

    init(title: String, detail: String? = nil, returnDate: Date? = nil) {
        self.title = title
        self.detail = detail
        self.returnDate = returnDate
    }
}

protocol CreateReturnItemUseCase {
    func execute(request: CreateReturnItemRequest) throws
}
