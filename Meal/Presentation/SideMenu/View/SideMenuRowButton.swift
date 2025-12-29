//
//  MenuRowButton.swift
//  Meal
//

import Foundation
import UIKit

class SideMenuRowButton: UIButton {
    init(title: String, icon: String) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: icon)
        config.imagePadding = 12
        config.baseForegroundColor = .white
        
        var titleAttr = AttributedString(title)
        titleAttr.font = .systemFont(ofSize: 16, weight: .medium)
        config.attributedTitle = titleAttr
        
        self.configuration = config
        self.contentHorizontalAlignment = .leading
        
        self.configurationUpdateHandler = { button in
            button.alpha = button.isHighlighted ? 0.5 : 1.0
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
