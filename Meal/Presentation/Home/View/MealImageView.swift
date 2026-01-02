//
//  MealImageView.swift
//  Meal
//

import UIKit
import SnapKit

final class MealImageView: UIView {
    private static let imageCache = NSCache<NSString, UIImage>()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let innerBorderView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.isUserInteractionEnabled = false
        return v
    }()
    
    private let leftBorder = UIView()
    private let rightBorder = UIView()
    private let topBorder = UIView()
    private let bottomBorder = UIView()
    
    private var currentImageURL: URL?
    private var aspectRatioConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBorderLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(imageURL: URL?) {
        currentImageURL = imageURL
        prepareForReuse()
        
        guard let url = imageURL else { return }
        
        if let cached = Self.imageCache.object(forKey: url.absoluteString as NSString) {
            updateImage(cached)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data, let image = UIImage(data: data),
                  self.currentImageURL == url else { return }
            
            Self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                self.updateImage(image)
            }
        }.resume()
    }

    private func updateImage(_ image: UIImage) {
        imageView.image = image
        applyAspectRatio(image)
    }
    
    func prepareForReuse() {
        imageView.image = nil
        aspectRatioConstraint?.deactivate()
        aspectRatioConstraint = nil
    }
    
    private func applyAspectRatio(_ image: UIImage) {
        let ratio = image.size.height / max(image.size.width, 1)
        
        aspectRatioConstraint?.deactivate()
        
        imageView.snp.remakeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            self.aspectRatioConstraint = make.height.equalTo(imageView.snp.width).multipliedBy(ratio).constraint
        }
        
        self.setNeedsLayout()
        self.superview?.setNeedsLayout()
    }
    
    private func setupUI() {
        addSubview(imageView)
        imageView.addSubview(innerBorderView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        innerBorderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBorderLayout() {
        let borderColor = UIColor.white
        
        [leftBorder, rightBorder, topBorder, bottomBorder].forEach {
            $0.backgroundColor = borderColor
            innerBorderView.addSubview($0)
        }
        
        leftBorder.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(4)
        }
        
        rightBorder.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(4)
        }
        
        topBorder.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        bottomBorder.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
    }
}
