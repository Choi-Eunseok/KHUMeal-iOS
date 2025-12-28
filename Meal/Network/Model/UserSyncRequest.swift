//
//  UserSyncRequest.swift
//  Meal
//

import Foundation

struct UserSyncRequest: Encodable {
    let user_id: String
    let fcm_token: String
    let platform: String
}
