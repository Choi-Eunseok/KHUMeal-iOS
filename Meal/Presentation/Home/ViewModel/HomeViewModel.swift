//
//  HomeViewModel.swift
//  Meal
//

import Foundation

class HomeViewModel {
    var onUpdate: (() -> Void)?
    
    private let lastSelectedKey = "lastSelectedRestaurantName"
    
    var restaurantName: String = "로딩 중..." {
        didSet {
            UserDefaults.standard.set(restaurantName, forKey: lastSelectedKey)
            onUpdate?()
        }
    }
    
    var lastSavedName: String? {
        return UserDefaults.standard.string(forKey: lastSelectedKey)
    }
    
    var weeklyMeals: [DailyMealInfo] = [] {
        didSet { onUpdate?() }
    }
    
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
        Task {
            do {
                let weeklyData = try await MealService.shared.fetchThisWeekMeals(restaurantId: restaurantId)
                
                await MainActor.run {
                    self.weeklyMeals = weeklyData
                    self.onUpdate?()
                }
            } catch {
                print("데이터 로드 실패: \(error)")
            }
        }
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
