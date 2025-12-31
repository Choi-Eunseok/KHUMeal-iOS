//
//  TopBarView.swift
//  Meal
//

import UIKit
import SnapKit

final class TopBarView: UIView {
    
    let leftButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "line.3.horizontal", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    func configure(title: String, iconName: String, backColor: UIColor, frontColor: UIColor) {
        titleLabel.text = title
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        leftButton.setImage(UIImage(systemName: iconName, withConfiguration: config), for: .normal)
        
        backgroundColor = backColor
        leftButton.tintColor = frontColor
        titleLabel.textColor = frontColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = .mainRed
        addSubview(leftButton)
        addSubview(titleLabel)
        
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-15)
            make.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftButton.snp.trailing).offset(12)
            make.centerY.equalTo(leftButton)
        }
    }
}
