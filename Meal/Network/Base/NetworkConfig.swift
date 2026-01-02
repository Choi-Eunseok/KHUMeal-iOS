//
//  NetworkConfig.swift
//  Meal
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
}

enum NetworkConfig {
    static var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    }
    
    static var commonHeaders: [String: String] {
        return ["Content-Type": "application/json"]
    }
}
