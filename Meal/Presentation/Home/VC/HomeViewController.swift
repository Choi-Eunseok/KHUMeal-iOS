//
//  ViewController.swift
//  Meal
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    var onMenuButtonTapped: (() -> Void)?
    let viewModel = HomeViewModel()

    private let topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainRed
        return view
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 32)
        button.setImage(UIImage(systemName: "line.3.horizontal", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(topBar)
        topBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        topBar.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        topBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(menuButton)
        }
        
    }

    func updateRestaurant(_ restaurant: Restaurant) {
        viewModel.restaurant = restaurant
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.titleLabel.text = self.viewModel.restaurant.name
        }
    }
    
    @objc private func menuTapped() {
        onMenuButtonTapped?()
    }
}

#Preview {
    return HomeViewController()
}
