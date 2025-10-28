//
//  Realm.swift
//  SakeLog
//
//  Created by Takane on 2025/10/29.
//

import Foundation
import RealmSwift

// MARK: - Realm Models

// User Model
class User: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var username: String
    @Persisted var email: String
    @Persisted var theme: String = "light" // Default theme
    @Persisted var plan: String = "free" // Default plan
    @Persisted var createdAt: Date = Date()
    
    convenience init(username: String, email: String) {
        self.init()
        self.username = username
        self.email = email
    }
}
// Dummy User for Preview
extension User {
    static func dummy() -> User {
        return User(username: "testuser", email: "test@com.com")
    }
}

// SakeLog Model
class SakeLog: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var userId: ObjectId
    @Persisted var brandId: Int?
    @Persisted var kind: String
    @Persisted var labelUrl: String
    @Persisted var rating: Int?
    @Persisted var notes: String?
    @Persisted var date: Date = Date()
    
    convenience init(userId: ObjectId, brandId: Int?, kind: String, laeblUrl: String, rating: Int?, notes: String?) {
        self.init()
        self.userId = userId
        self.brandId = brandId
        self.rating = rating
        self.notes = notes
    }
}
// Dummy SakeLog for Preview
extension SakeLog {
    static func dummy() -> SakeLog {
        return SakeLog(userId: User.dummy().id, brandId: 1, kind: "純米大吟醸", laeblUrl: "https://example.com/label.png", rating: 4, notes: "とても美味しいお酒でした。")
    }
}

// MARK: - Realm Configuration
let config = Realm.Configuration(
    schemaVersion: 1,
    deleteRealmIfMigrationNeeded: false // 本番ビルド時にfalseにすること
)

let realm = try! Realm(configuration: config)
