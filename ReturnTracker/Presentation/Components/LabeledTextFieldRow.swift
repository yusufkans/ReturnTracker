//
//  LabeledTextFieldRow.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 21.01.2026.
//

import Foundation
import SwiftUI

struct LabeledTextFieldRow: View {
    private let title: String
    private let placeholder: String
    @Binding private var text: String

    init(title: String, placeholder: String, text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    LabeledTextFieldRow(
        title: NSLocalizedString("new.item_name", comment: "Item name field label"),
        placeholder: NSLocalizedString("new.item_name.placeholder", comment: "Item name placeholder"),
        text: .constant("")
    )
    .padding()
}
