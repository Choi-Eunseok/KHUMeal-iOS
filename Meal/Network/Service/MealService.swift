//
//  MealService.swift
//  Meal
//

import Foundation

class MealService: BaseService {
    static let shared = MealService()
    private override init() {}
    
    func fetchThisWeekMeals(restaurantId: Int) async throws -> [DailyMealInfo] {
        let endpoint = "\(NetworkConfig.baseURL)/api/menu/week/this/\(restaurantId)"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError((response as? HTTPURLResponse)?.statusCode ?? 500)
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return try decoder.decode([DailyMealInfo].self, from: data)
    }
}
