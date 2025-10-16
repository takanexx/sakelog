//
//  BrandListView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/16.
//

import SwiftUI

struct BrandListView: View {
    @State private var searchText = ""
    private let allBrands = Brand.loadFromJSON()
    
    private var filteredBrands: [Brand] {
        if searchText.isEmpty {
            return allBrands
        } else {
            return allBrands.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredBrands) { brand in
                VStack(alignment: .leading) {
                    Text(brand.name)
                        .font(.headline)
                    if let breweryId = brand.breweryId {
                        Text("Brewery ID: \(breweryId)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
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
    BrandListView()
}

