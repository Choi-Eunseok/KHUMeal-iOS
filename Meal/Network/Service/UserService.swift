//
//  UserService.swift
//  Meal
//

import Foundation

class UserService: BaseService {
    static let shared = UserService()
    private override init() {}
    
    func syncUser(deviceID: String, fcmToken: String) async throws {
        let endpoint = "\(NetworkConfig.baseURL)/api/v1/users/sync"
        let body = UserSyncRequest(
            user_id: deviceID,
            fcm_token: fcmToken,
            platform: "ios"
        )
        
        try await request(url: endpoint, method: "POST", body: body)
    }
}
