//
//  Meal.swift
//  Meal
//

import Foundation

struct MealCategory {
    let uuid: String
    let title: String
    let menus: [String]
    let image: String?
}

struct DailyMealInfo {
    let date: Date
    let categories: [MealCategory]
}

enum MealContentMode {
    case text
    case image
}
