//
//  MealCategoryView.swift
//  Meal
//

import UIKit
import SnapKit

class MealCategoryView: UIView {
    
    private var categoryUuid: String?
    var onMenuHighlightChanged: ((String, Int, Bool) -> Void)?
    
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
    
    func configure(with category: MealCategory, mode: MealContentMode) {
        self.categoryUuid = category.uuid
        titleLabel.text = category.title
        apply(mode: mode)
        
        switch mode {
        case .text:
            menuStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            for (index, menuText) in category.menus.enumerated() {
                let itemView = MealMenuItemView(text: menuText)
                
                itemView.onToggleHighlight = { [weak self] isSelected in
                    guard let self = self, let uuid = self.categoryUuid else { return }
                    self.onMenuHighlightChanged?(uuid, index, isSelected)
                }
                
                menuStackView.addArrangedSubview(itemView)
            }
            imageView.prepareForReuse()
            
        case .image:
            let url = URL(string: category.image ?? "")
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
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
}
