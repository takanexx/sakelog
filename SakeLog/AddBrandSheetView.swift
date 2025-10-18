//
//  AddBrandSheetView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/18.
//

import SwiftUI

struct AddBrandSheetView: View {
    @Binding var selectedBrand: Brand?
    
    var body: some View {
        // ブランドが選択されている場合は詳細表示、そうでなければリスト表示
        if selectedBrand != nil {
            HStack {
                Text("Brand Name")
                Button("はずす") {
                    selectedBrand = nil
                }
            }
            HStack (alignment: .bottom, spacing: 10) {
                Text("🍶")
                    .font(.title)
                Text(selectedBrand!.name)
                    .font(.title)
                Text(selectedBrand!.brewery?.name ?? "")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .baselineOffset(3)
            }
        } else {
            BrandListView(selectedBrand: $selectedBrand)
        }
    }
}


#Preview {
    AddBrandSheetView(selectedBrand: .constant(nil))
}
