//
//  Brand.swift
//  SakeLog
//
//  Created by Takane on 2025/10/16.

import Foundation

struct Brand: Identifiable, Codable {
    let id: Int
    let name: String
    let breweryId: Int?
    
    static func loadFromJSON() -> [Brand] {
        guard let url = Bundle.main.url(forResource: "brands", withExtension: "json") else {
            print("❌ brands.json が見つかりません")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let brands = try JSONDecoder().decode([Brand].self, from: data)
            return brands
        } catch {
            print("❌ JSON読み込みエラー: \(error)")
            return []
        }
    }
}
