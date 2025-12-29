//
//  SideMenuViewModel.swift
//  Meal
//

import Foundation

class SideMenuViewModel {
    var onUpdate: (() -> Void)?
    
    private(set) var restaurants: [Restaurant] = [] {
        didSet { onUpdate?() }
    }
    
    let settingsTitle = "설정"
    let settingsIcon = "gearshape"

    func fetchMenuData() {
        Task {
            do {
                let list = try await RestaurantService.shared.fetchRestaurants()
                await MainActor.run {
                    self.restaurants = list
                }
            } catch {
                print("메뉴 로드 실패")
            }
        }
    }
}
