//
//  Meal.swift
//  Meal
//

import Foundation

struct MealCategory: Codable {
    let uuid: String
    let title: String
    let menus: [String]
    private let imagePath: String?

    enum CodingKeys: String, CodingKey {
        case uuid = "menuInfoUuid"
        case title = "cornerName"
        case menus = "items"
        case imagePath = "imageUrl"
    }
    
    var image: String? {
        guard let path = imagePath else { return nil }
        return NetworkConfig.baseURL + path
    }
}

struct DailyMealInfo: Codable {
    let restaurantName: String
    let date: Date
    let categories: [MealCategory]

    enum CodingKeys: String, CodingKey {
        case restaurantName
        case date
        case categories = "menuItems"
    }
}

enum MealContentMode {
    case text
    case image
}
