//
//  SideMenuViewController.swift
//  Meal
//

import UIKit
import SnapKit

protocol SideMenuDelegate: AnyObject {
    func didSelectRestaurant(_ restaurant: Restaurant)
    func sideMenuDidInitialLoad(with restaurants: [Restaurant])
    func didSelectSettings()
}

class SideMenuViewController: UIViewController {
    weak var delegate: SideMenuDelegate?
    private let viewModel = SideMenuViewModel()
    private let glassBackground = LiquidGlassView()
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseUI()
        bindViewModel()
        viewModel.fetchMenuData()
    }

    private func setupBaseUI() {
        view.backgroundColor = .clear
        
        view.addSubview(glassBackground)
        glassBackground.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.renderMenu()
            self.initializeFirstSelection()
        }
    }

    private func renderMenu() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let titleContainer = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = "학식"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleContainer.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview()
        }
        contentStackView.addArrangedSubview(titleContainer)
        contentStackView.setCustomSpacing(30, after: titleContainer)
        
        for res in viewModel.restaurants {
            let btn = SideMenuRowButton(title: res.name, icon: "fork.knife")
            btn.addAction(UIAction(handler: { [weak self] _ in
                self?.delegate?.didSelectRestaurant(res)
            }), for: .touchUpInside)
            
            contentStackView.addArrangedSubview(btn)
        }
        
        let line = UIView()
        line.backgroundColor = .white.withAlphaComponent(0.1)
        line.snp.makeConstraints { $0.height.equalTo(0.5) }
        contentStackView.addArrangedSubview(line)
        contentStackView.setCustomSpacing(20, after: line)
        
        let settingsBtn = SideMenuRowButton(title: viewModel.settingsTitle, icon: viewModel.settingsIcon)
        contentStackView.addArrangedSubview(settingsBtn)
        settingsBtn.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.didSelectSettings()
        }), for: .touchUpInside)
    }
    
    private func initializeFirstSelection() {
        let list = viewModel.restaurants
        guard !list.isEmpty else { return }
        
        self.delegate?.sideMenuDidInitialLoad(with: list)
    }
}
