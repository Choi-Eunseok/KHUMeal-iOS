//
//  SettingItemSwitchView.swift
//  Meal
//

import UIKit
import SnapKit

final class SettingItemSwitchView: UIView {
    private let titleLabel = UILabel()
    private let controlSwitch = UISwitch()
    private let storageKey: String
    
    init(title: String, key: String) {
        self.storageKey = key
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.controlSwitch.isOn = UserDefaults.standard.bool(forKey: key)
        setupUI()
        
        controlSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        
        addSubview(titleLabel)
        addSubview(controlSwitch)
        
        self.snp.makeConstraints { $0.height.equalTo(60) }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        controlSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func switchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: storageKey)
        
        NotificationCenter.default.post(name: NSNotification.Name("DisplayModeChanged"), object: nil)
    }
}
