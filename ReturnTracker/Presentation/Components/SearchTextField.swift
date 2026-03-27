//
//  SearchTextField.swift
//  ReturnTracker
//
//  Created by Codex on 27.03.2026.
//

import SwiftUI

struct SearchTextField<LeadingAccessory: View, TrailingAccessory: View>: View {
    private let placeholder: String
    @Binding private var text: String
    private let leadingAccessory: LeadingAccessory
    private let trailingAccessory: TrailingAccessory

    init(
        placeholder: String,
        text: Binding<String>,
        @ViewBuilder leadingAccessory: () -> LeadingAccessory,
        @ViewBuilder trailingAccessory: () -> TrailingAccessory
    ) {
        self.placeholder = placeholder
        _text = text
        self.leadingAccessory = leadingAccessory()
        self.trailingAccessory = trailingAccessory()
    }

    var body: some View {
        HStack(spacing: 8) {
            leadingAccessory
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)

            trailingAccessory
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        }
    }
}

extension SearchTextField where LeadingAccessory == EmptyView {
    init(
        placeholder: String,
        text: Binding<String>,
        @ViewBuilder trailingAccessory: () -> TrailingAccessory
    ) {
        self.init(
            placeholder: placeholder,
            text: text,
            leadingAccessory: { EmptyView() },
            trailingAccessory: trailingAccessory
        )
    }
}

extension SearchTextField where TrailingAccessory == EmptyView {
    init(
        placeholder: String,
        text: Binding<String>,
        @ViewBuilder leadingAccessory: () -> LeadingAccessory
    ) {
        self.init(
            placeholder: placeholder,
            text: text,
            leadingAccessory: leadingAccessory,
            trailingAccessory: { EmptyView() }
        )
    }
}

#Preview {
    SearchTextField(
        placeholder: L10n.Returns.searchPlaceholder,
        text: .constant(""),
        leadingAccessory: {
            Image(systemName: "magnifyingglass")
                .font(.subheadline)
        }
    )
    .padding()
}
