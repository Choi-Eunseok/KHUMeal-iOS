//
//  BaseService.swift
//  Meal
//

import Foundation

class BaseService {
    func request(url: String, method: String, body: Encodable?) async throws {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        NetworkConfig.commonHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
