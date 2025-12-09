//
//  AboutSakeDataView.swift
//  SakeLog
//
//  Created by Takane on 2025/12/10.
//

import SwiftUI

struct AboutSakeDataView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("銘柄データについて")
                .font(.title3)
                .bold()
            Text("SakeLogに搭載されている日本酒の銘柄データは、オープンデータとして公開されている「さけのわデータ」を基に作成されています。このデータベースには、多数の日本酒の情報が含まれており、SakeLogではその一部を利用しています。")
            Link(destination: URL(string: "https://sakenowa.com")!) {
                HStack(spacing: 6) {
                    Image(systemName: "link")
                        .font(.headline)
                    Text("さけのわデータ")
                }
                .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

#Preview {
    AboutSakeDataView()
}
