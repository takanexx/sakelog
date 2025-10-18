//
//  CabinetView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/13.
//
import SwiftUI
import SceneKit

struct CabinetView: View {
    @State private var isShow = false
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<20) { index in
                        ModelRenderView(labelImageName: "izumi", allowsCameraControl: false)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                    }
                }
                .padding()
            }
            .navigationTitle("Cabinet")
            .navigationBarTitleDisplayMode(.inline) // タイトルを小さく中央寄せ
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("右上ボタン tapped")
                        isShow.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShow) {
                BrandListView()
            }
        }
    }
}

#Preview {
    CabinetView()
}
