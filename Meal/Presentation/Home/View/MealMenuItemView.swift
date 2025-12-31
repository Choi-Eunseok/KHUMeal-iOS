//
//  MealMenuItemView.swift
//  Meal
//

import UIKit
import SnapKit

final class MealMenuItemView: UIView {
    
    var onToggleHighlight: ((Bool) -> Void)?
    
    private let highlightView: UIView = {
        let v = UIView()
        v.backgroundColor = .yellow.withAlphaComponent(0.4)
        v.isHidden = true
        v.layer.cornerRadius = 4
        return v
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var isHighlighted: Bool = false {
        didSet { highlightView.isHidden = !isHighlighted }
    }

    init(text: String) {
        super.init(frame: .zero)
        label.text = text
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        addSubview(highlightView)
        addSubview(label)
        
        highlightView.snp.makeConstraints { make in
            make.center.equalTo(label)
            make.width.equalTo(label).offset(8)
            make.height.equalTo(label).offset(4)
        }
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc private func handleDoubleTap() {
        isHighlighted.toggle()
        
        onToggleHighlight?(isHighlighted)
        
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
    }
}
