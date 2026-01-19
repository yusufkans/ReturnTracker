//
//  ProductMainCell.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 19.01.2026.
//

import SwiftUI

struct ProductMainCell: View {
    var body: some View {
        RoundedCardCell {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("Amazon — Running Shoes")
                                .font(.headline)
                            Text("Last day: Jan 28, 2026")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(.systemGray))
                                .frame(maxWidth: 64, maxHeight: 64)
                            
                            Text("12d")
                                .fontWeight(.bold)
                                .font(.title2)
                        }
                    }
                    
                    HStack {
                        Button {
                            print("Returned Tapped")
                        } label: {
                            Text("Returned")
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button {
                            print("Archive Tapped")
                        } label: {
                            Text("Archive")
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
        }
    }
}

#Preview {
    ProductMainCell()
        .padding()
}
