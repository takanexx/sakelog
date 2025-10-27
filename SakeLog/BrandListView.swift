//
//  BrandListView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/16.
//

import SwiftUI

struct BrandListView: View {
    @Binding var selectedBrand: Brand?
    @State private var searchText = ""
    private let allBrands = Brand.loadFromJSON()
    
    private var filteredBrands: [Brand] {
        if searchText.isEmpty {
            return allBrands
        } else {
            return allBrands.filter { $0.name.localizedCaseInsensitiveContains(searchText) ||
                ($0.brewery?.name.localizedCaseInsensitiveContains(searchText) ?? false)

            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredBrands) { brand in
                Button(action: {
                    selectedBrand = brand
                    // 軽い振動
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(brand.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            if let brewery = brand.brewery {
                                Text("酒蔵: \(brewery.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        if let area = brand.brewery?.area {
                            Text(area.name)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("ブランド一覧")
            .searchable(text: $searchText, prompt: "ブランド名を検索")
        }
    }
}

#Preview {
    BrandListView(selectedBrand: .constant(nil))
}

