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
    
    var highlightedUuids: Set<String> = []
    
    var onLoadingStatusChanged: ((Bool) -> Void)?
    
    init() {
        
    }
    
    func changeRestaurant(to restaurant: Restaurant) {
        self.weeklyMeals = []
        self.restaurantName = restaurant.name
        fetchWeeklyData(for: restaurant.id)
    }
    
    func getTodayIndex() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let todayString = formatter.string(from: Date())
        
        return weeklyMeals.firstIndex(where: { formatter.string(from: $0.date) == todayString }) ?? 0
    }
    
    func fetchWeeklyData(for restaurantId: Int) {
        onLoadingStatusChanged?(true)
        Task {
            do {
                let weeklyData = try await MealService.shared.fetchThisWeekMeals(restaurantId: restaurantId)
                let allMenuItemUuids = weeklyData.flatMap { daily in
                        daily.menuInfos.flatMap { info in
                            info.items.map { $0.menuItemUuid }
                        }
                    }
                let highlightedUuids = try await UserService.shared.fetchUserHighlights(userId: self.userId, uuids: allMenuItemUuids)
                
                await MainActor.run {
                    self.highlightedUuids = highlightedUuids
                    self.weeklyMeals = weeklyData
                    self.onLoadingStatusChanged?(false)
                }
            } catch {
                await MainActor.run {
                    self.onLoadingStatusChanged?(false)
                }
                print("데이터 로드 실패: \(error)")
            }
        }
    }
    
    func syncHighlightStatus(uuid: String, status: Bool) {
        Task {
            do {
                try await UserService.shared.postHighlight(
                    menuItemUuid: uuid,
                    userId: userId,
                    status: status
                )
                
                if status {
                    highlightedUuids.insert(uuid)
                } else {
                    highlightedUuids.remove(uuid)
                }
                
                print("Successfully synced: \(uuid) as \(status)")
            } catch {
                print("Failed to sync highlight: \(error)")
            }
        }
    }
}
