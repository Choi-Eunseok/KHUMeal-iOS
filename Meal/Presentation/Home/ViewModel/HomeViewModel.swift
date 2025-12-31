//
//  HomeViewModel.swift
//  Meal
//

import Foundation

class HomeViewModel {
    var onUpdate: (() -> Void)?
    
    private let lastSelectedKey = "lastSelectedRestaurantName"
    
    var restaurantName: String = "로딩 중..." {
        didSet { onUpdate?() }
    }
    
    var lastSavedName: String? {
        return UserDefaults.standard.string(forKey: lastSelectedKey)
    }
    
    var weeklyMeals: [DailyMealInfo] = [] {
        didSet { onUpdate?() }
    }
    
//    private let mealService: MealService
    
    var userId: String {
            return UserDefaults.standard.string(forKey: "userId") ?? "Unknown_ID"
        }
    
    init() {
        
    }
    
    func changeRestaurant(to restaurant: Restaurant) {
        self.restaurantName = restaurant.name
        fetchWeeklyData(for: restaurant.id)
    }
    
    func fetchWeeklyData(for restaurantId: Int) {
        var dummyWeekly: [DailyMealInfo] = []
        let calendar = Calendar.current
        let today = Date()
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                let categories = [
                    MealCategory(uuid: "t", title: "교직원 소담", menus: ["메뉴 A", "메뉴 B"], image: "https://REPLACED_URL/api/image/7c8f9bbe-8891-4110-b881-e78a86a3c5c1"),
                    MealCategory(uuid: "t", title: "학생식당", menus: ["메뉴 C", "메뉴 D", "메뉴 E"], image: "https://REPLACED_URL/api/image/7c8f9bbe-8891-4110-b881-e78a86a3c5c1"),
                    MealCategory(uuid: "t", title: "교직원 소담", menus: ["메뉴 A", "메뉴 B"], image: "https://REPLACED_URL/api/image/7c8f9bbe-8891-4110-b881-e78a86a3c5c1"),
                    MealCategory(uuid: "t", title: "학생식당", menus: ["메뉴 C", "메뉴 D", "메뉴 E"], image: "https://REPLACED_URL/api/image/7c8f9bbe-8891-4110-b881-e78a86a3c5c1"),
                    MealCategory(uuid: "t", title: "교직원 소담", menus: ["메뉴 A", "메뉴 B"], image: "https://REPLACED_URL/api/image/7c8f9bbe-8891-4110-b881-e78a86a3c5c1"),
                    MealCategory(uuid: "t", title: "학생식당", menus: ["메뉴 C", "메뉴 D", "메뉴 E"], image: "https://REPLACED_URL/api/image/7c8f9bbe-8891-4110-b881-e78a86a3c5c1")
                ]
                dummyWeekly.append(DailyMealInfo(date: date, categories: categories))
            }
        }
        self.weeklyMeals = dummyWeekly
    }
    
    func syncHighlightStatus(uuid: String, index: Int, status: Bool) {
        print("User: \(self.userId), UUID: \(uuid), Index: \(index) as \(status)")
        
//        Task {
//            do {
//                try await MealService.shared.postHighlight(
//                    uuid: uuid,
//                    userId: userId,
//                    index: index,
//                    status: status
//                )
//                print("Successfully synced: \(uuid) [\(index)] as \(status)")
//            } catch {
//                print("Failed to sync highlight: \(error)")
//            }
//        }
    }
}
