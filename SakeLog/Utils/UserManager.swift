//
//  UserManager.swift
//  SakeLog
//
//  Created by Takane on 2025/11/06.
//

import Foundation
import RealmSwift
import Combine

class UserManager: ObservableObject {
    @Published var currentUser: User?
    private var realm: Realm

    init() {
        // Realm の初期化
        realm = try! Realm()
        loadUser()
    }

    /// 起動時にユーザーを読み込む
    func loadUser() {
        if let user = realm.objects(User.self).first {
            currentUser = user
        } else {
            currentUser = nil
        }
    }
    
    func getPlanText() -> String {
        switch currentUser?.plan {
        case "free":
            return "フリー"
        case "pro":
            return "プロ"
        default:
            return "不明"
        }
    }
}
