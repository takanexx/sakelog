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
    
    // 紐づく蔵情報
    var brewery: Brewery?
}

struct Brewery: Identifiable, Codable {
    let id: Int
    let name: String
    let areaId: Int
    
    // 紐づくエリア情報
    var area: Area?
}

struct Area: Identifiable, Codable {
    let id: Int
    let name: String
}

extension Brand {
    /// ブランド一覧をJSONから読み込み、brewery.jsonの内容と紐付けて返す
    static func loadFromJSON() -> [Brand] {
        // brands.json 読み込み
        guard let brandURL = Bundle.main.url(forResource: "brands", withExtension: "json") else {
            print("❌ brands.json が見つかりません")
            return []
        }
        
        // brewery.json 読み込み
        guard let breweryURL = Bundle.main.url(forResource: "brewery", withExtension: "json") else {
            print("❌ brewery.json が見つかりません")
            return []
        }
        
        // areas.json 読み込み
        guard let areaURL = Bundle.main.url(forResource: "areas", withExtension: "json") else {
            print("❌ areas.json が見つかりません")
            return []
        }
        
        do {
            let brandData = try Data(contentsOf: brandURL)
            let breweryData = try Data(contentsOf: breweryURL)
            let areaData = try Data(contentsOf: areaURL)
            
            var brands = try JSONDecoder().decode([Brand].self, from: brandData)
            let breweries = try JSONDecoder().decode([Brewery].self, from: breweryData)
            let areas = try JSONDecoder().decode([Area].self, from: areaData)
            
            // breweryIdを使って対応する蔵を紐付け
            for i in 0..<brands.count {
                if let breweryId = brands[i].breweryId {
                    brands[i].brewery = breweries.first(where: { $0.id == breweryId })
                    // 蔵に対応するエリアも紐付け
                    if let brewery = brands[i].brewery {
                        brands[i].brewery?.area = areas.first(where: { $0.id == brewery.areaId })
                    }
                }
            }
            
            print("✅ ブランド: \(brands.count)件, 蔵: \(breweries.count)件 読み込み完了")
            return brands
        } catch {
            print("❌ JSON読み込みエラー: \(error)")
            return []
        }
    }
}
