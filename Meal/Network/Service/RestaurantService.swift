//
//  MealService.swift
//  Meal
//

import Foundation

class RestaurantService: BaseService {
    static let shared = RestaurantService()
    private override init() {}
    
    func fetchRestaurants() async throws -> [Restaurant] {
        let endpoint = "\(NetworkConfig.baseURL)/api/restaurant"
         let (data, _) = try await URLSession.shared.data(from: URL(string: endpoint)!)
         return try JSONDecoder().decode([Restaurant].self, from: data)
    }
}
