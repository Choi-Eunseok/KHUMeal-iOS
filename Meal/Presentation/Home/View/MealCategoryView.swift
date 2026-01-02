//
//  MealCategoryView.swift
//  Meal
//

import UIKit
import SnapKit

class MealCategoryView: UIView {
    
    private var categoryUuid: String?
    var onMenuHighlightChanged: ((String, Bool) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let imageView = MealImageView()
    
    private let menuStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func apply(mode: MealContentMode) {
        menuStackView.isHidden = (mode != .text)
        imageView.isHidden = (mode != .image)
    }
    
    func configure(with menuInfo: MenuInfo, mode: MealContentMode, highlightedUuids: Set<String>) {
        self.categoryUuid = menuInfo.menuInfoUuid
        titleLabel.text = menuInfo.cornerName
        apply(mode: mode)
        
        switch mode {
        case .text:
            menuStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            for item in menuInfo.items {
                let itemView = MealMenuItemView(text: item.menuItemName)
                
                itemView.isHighlighted = highlightedUuids.contains(item.menuItemUuid)
                
                itemView.onToggleHighlight = { [weak self] isSelected in
                    guard let self = self else { return }
                    // 이제 인덱스가 아닌 아이템의 고유 UUID를 쏩니다.
                    self.onMenuHighlightChanged?(item.menuItemUuid, isSelected)
                }
                
                menuStackView.addArrangedSubview(itemView)
            }
            imageView.prepareForReuse()
            
        case .image:
            let url = URL(string: menuInfo.image ?? "")
            imageView.configure(imageURL: url)
        }
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
        
        addSubview(titleLabel)
        addSubview(separator)
        addSubview(menuStackView)
        addSubview(imageView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview().inset(24)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
