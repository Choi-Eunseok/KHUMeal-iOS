//
//  SettingsViewController.swift
//  Meal
//

import UIKit
import SnapKit

final class SettingsViewController: UIViewController {
    
    private let topBarView = TopBarView()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private let modeSwitchView = SettingItemSwitchView(title: "이미지로 식단 보기", key: "isImageMode")

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .systemGroupedBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(topBarView)
        view.addSubview(contentStackView)
        
        topBarView.configure(title: "설정", iconName: "chevron.left", backColor: .mainBlue, frontColor: .white)
        
        topBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        topBarView.leftButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        contentStackView.addArrangedSubview(modeSwitchView)
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
