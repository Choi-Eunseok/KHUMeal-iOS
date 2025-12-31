//
//  UILabel.swift
//  Meal
//

import UIKit

extension UILabel {
    func setLineHeight(_ lineHeight: CGFloat) {
        guard let text = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let baselineOffset = (lineHeight - font.lineHeight) / 2
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize),
            .paragraphStyle: paragraphStyle,
            .baselineOffset: baselineOffset,
            .foregroundColor: self.textColor ?? UIColor.label
        ]
        
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
