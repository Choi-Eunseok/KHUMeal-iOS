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
            userId: deviceID,
            fcmToken: fcmToken,
            platform: "ios"
        )
        
        try await request(url: endpoint, method: "POST", body: body)
    }
    
    func fetchUserHighlights(userId: String, uuids: [String]) async throws -> Set<String> {
        let uuidParams = uuids.joined(separator: ",")
        let endpoint = "\(NetworkConfig.baseURL)/api/v1/users/\(userId)/highlights?menuUuids=\(uuidParams)"
        
        let data = try await requestWithData(url: endpoint, method: "GET", body: nil)
        let response = try JSONDecoder().decode(UserHighlightResponse.self, from: data)
        
        return Set(response.highlightedUuids)
    }
    
    func postHighlight(menuItemUuid: String, userId: String, status: Bool) async throws {
        let endpoint = "\(NetworkConfig.baseURL)/api/v1/users/highlight"
        
        let body = UserHighlightRequest(
            userId: userId,
            menuItemUuid: menuItemUuid,
            isHighlighted: status
        )
        
        try await request(url: endpoint, method: "POST", body: body)
    }
    
}
