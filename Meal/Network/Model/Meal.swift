//
//  Meal.swift
//  Meal
//

import Foundation

struct DailyMealInfo: Codable {
    let restaurantName: String
    let date: Date
    let menuInfos: [MenuInfo]
}

struct MenuInfo: Codable {
    let menuInfoUuid: String
    let cornerName: String
    let items: [MenuItem]
    let imageUrl: String?
    var image: String? {
        guard let path = imageUrl else { return nil }
        return NetworkConfig.baseURL + path
    }
}

struct MenuItem: Codable {
    let menuItemUuid: String
    let menuItemName: String
}

enum MealContentMode {
    case text
    case image
}
