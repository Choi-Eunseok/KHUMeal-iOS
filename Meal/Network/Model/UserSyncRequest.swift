//
//  UserSyncRequest.swift
//  Meal
//

import Foundation

struct UserSyncRequest: Codable {
    let userId: String
    let fcmToken: String
    let platform: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case fcmToken = "fcm_token"
        case platform = "platform"
    }
}
