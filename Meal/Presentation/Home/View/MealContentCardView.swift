//
//  MealContentCardView.swift
//  Meal
//

import UIKit
import SnapKit

final class MealContentCardView: UIView {
    
    var onMenuHighlightChanged: ((String, Bool) -> Void)?
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let topDateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        view.layer.masksToBounds = true
        return view
    }()
    
    private let gradientBackgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    private let gradientLayer = CAGradientLayer()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .clear
        sv.showsVerticalScrollIndicator = false
        sv.layer.cornerRadius = 30
        sv.layer.maskedCorners = [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner
        ]
        sv.layer.masksToBounds = true
        return sv
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(date: Date, menuInfos: [MenuInfo], mode: MealContentMode, highlightedUuids: Set<String>) {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "E요일"
        dayFormatter.locale = Locale(identifier: "ko_KR")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        
        dayLabel.text = dayFormatter.string(from: date)
        dateLabel.text = formatter.string(from: date)
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for menuInfo in menuInfos {
            let categoryView = MealCategoryView()
            categoryView.configure(with: menuInfo, mode: mode, highlightedUuids: highlightedUuids)
            categoryView.onMenuHighlightChanged = { [weak self] uuid, status in
                self?.onMenuHighlightChanged?(uuid, status)
            }
            stackView.addArrangedSubview(categoryView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientBackgroundView.bounds
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(topDateView)
        addSubview(gradientBackgroundView)
        addSubview(scrollView)
        
        topDateView.addSubview(dayLabel)
        topDateView.addSubview(dateLabel)
        topDateView.addSubview(separatorLine)
        
        scrollView.addSubview(stackView)
        
        topDateView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        gradientBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(topDateView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topDateView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide).inset(UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0))
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1).cgColor,
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations  = [0.0, 1.0]
        
        gradientBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
    
        gradientBackgroundView.layer.cornerRadius = 30
        gradientBackgroundView.layer.maskedCorners = [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner
        ]
        gradientBackgroundView.layer.masksToBounds = true
    }
}
