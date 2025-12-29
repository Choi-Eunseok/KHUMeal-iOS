//
//  HomeViewModel.swift
//  Meal
//

import Foundation

class HomeViewModel {
    var onUpdate: (() -> Void)?
    
    private let lastSelectedKey = "lastSelectedRestaurantName"
    
    var restaurant: Restaurant = Restaurant(id: 0, name: "오늘의 식단") {
        didSet {
            UserDefaults.standard.set(restaurant.name, forKey: lastSelectedKey)
            onUpdate?()
        }
    }
    
    var lastSavedName: String? {
        return UserDefaults.standard.string(forKey: lastSelectedKey)
    }
}
