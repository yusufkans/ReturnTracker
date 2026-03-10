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
        title: L10n.New.itemName,
        placeholder: L10n.New.itemNamePlaceholder,
        text: .constant("")
    )
    .padding()
}
