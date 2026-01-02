//
//  BaseService.swift
//  Meal
//

import Foundation

class BaseService {
    func request(url: String, method: String, body: Encodable?) async throws {
        _ = try await requestWithData(url: url, method: method, body: body)
    }
    
    func requestWithData(url: String, method: String, body: Encodable?) async throws -> Data {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        NetworkConfig.commonHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        if let body = body {
            let jsonData = try JSONEncoder().encode(body)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("🚀 Sending JSON: \(jsonString)")
            }
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
