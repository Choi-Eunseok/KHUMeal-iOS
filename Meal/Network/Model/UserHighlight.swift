//
//  UserHighlight.swift
//  Meal
//

import Foundation

struct UserHighlightRequest: Codable {
    let userId: String
    let menuItemUuid: String
    let isHighlighted: Bool
}

struct UserHighlightResponse: Codable {
    let highlightedUuids: [String]
}
