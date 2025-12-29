//
//  MainContainerViewController.swift
//  Meal
//

import UIKit
import SnapKit

class MainContainerViewController: UIViewController {
    
    private let sideMenuVC = SideMenuViewController()
    private let homeVC = HomeViewController()
    private var isMenuOpen = false
    
    private var menuWidth: CGFloat {
        return self.view.bounds.width * 0.75
    }
    
    private let homeWrapperView = UIView()
    
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.alpha = 0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildVC()
        setupGestures()
    }
    
    private func setupChildVC() {
        view.addSubview(homeWrapperView)
        homeWrapperView.frame = view.bounds
        let nav = UINavigationController(rootViewController: homeVC)
        addChild(nav)
        homeWrapperView.addSubview(nav.view)
        nav.view.frame = homeWrapperView.bounds
        nav.didMove(toParent: self)
        
        view.addSubview(dimView)
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sideMenuVC.delegate = self
        addChild(sideMenuVC)
        view.addSubview(sideMenuVC.view)
        sideMenuVC.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.bounds.height)
        sideMenuVC.didMove(toParent: self)
        
        homeVC.onMenuButtonTapped = { [weak self] in
            self?.toggleMenu()
        }
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleMenu))
        dimView.addGestureRecognizer(tap)
    }
    
    @objc func toggleMenu() {
        isMenuOpen.toggle()
        
        let targetX: CGFloat = isMenuOpen ? 0 : -menuWidth
        
        UIView.animate(withDuration: 0.4, delay: 0) {
            self.sideMenuVC.view.frame.origin.x = targetX
            self.dimView.alpha = self.isMenuOpen ? 1 : 0
        }
    }
}

extension MainContainerViewController: SideMenuDelegate {
    func didSelectRestaurant(_ restaurant: Restaurant) {
        toggleMenu()
        homeVC.updateRestaurant(restaurant)
    }
    
    func sideMenuDidInitialLoad(with restaurants: [Restaurant]) {
        let lastSavedName = homeVC.viewModel.lastSavedName
        
        let target = restaurants.first { $0.name == lastSavedName } ?? restaurants.first
        
        if let restaurant = target {
            homeVC.updateRestaurant(restaurant)
        }
    }
}
