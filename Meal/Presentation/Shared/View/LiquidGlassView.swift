//
//  LiquidGlassView.swift
//  Meal
//

import UIKit
import SnapKit

class LiquidGlassView: UIView {
    
    private let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        return UIVisualEffectView(effect: blurEffect)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
    }
}
