//
//  ViewController.swift
//  Meal
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    var onMenuButtonTapped: (() -> Void)?
    let viewModel = HomeViewModel()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let topBarView = TopBarView()
    private let touchContainer = UIView()
    
    private let pagingScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.clipsToBounds = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTouchDelegation()
        bindViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleModeChange), name: NSNotification.Name("DisplayModeChanged"), object: nil)
    }
    
    @objc private func handleModeChange() {
        self.renderWeeklyCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .mainRed
        
        view.addSubview(loadingIndicator)
        view.addSubview(topBarView)
        view.addSubview(touchContainer)
        touchContainer.addSubview(pagingScrollView)
        pagingScrollView.addSubview(horizontalStackView)
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        topBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }
        topBarView.leftButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        
        touchContainer.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        pagingScrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.edges.height.equalToSuperview()
        }
    }
    
    func updateRestaurant(_ restaurant: Restaurant) {
        viewModel.changeRestaurant(to: restaurant)
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.topBarView.titleLabel.text = self.viewModel.restaurantName
            self.renderWeeklyCards()
            DispatchQueue.main.async {
                self.scrollToToday(animated: false)
            }
        }
        viewModel.onLoadingStatusChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                    self?.pagingScrollView.alpha = 0.5
                } else {
                    self?.loadingIndicator.stopAnimating()
                    self?.pagingScrollView.alpha = 1.0
                }
            }
        }
    }
    
    private func setupTouchDelegation() {
        let panGesture = pagingScrollView.panGestureRecognizer
        touchContainer.addGestureRecognizer(panGesture)
    }
    
    private func renderWeeklyCards() {
        let isImageMode = UserDefaults.standard.bool(forKey: "isImageMode")
        let currentMode: MealContentMode = isImageMode ? .image : .text
        horizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for mealInfo in viewModel.weeklyMeals {
            let page = UIView()
            page.backgroundColor = .clear
            let card = MealContentCardView()
            
            horizontalStackView.addArrangedSubview(page)
            page.addSubview(card)
            
            page.snp.makeConstraints { make in
                make.width.equalTo(pagingScrollView.snp.width)
            }
            
            card.update(date: mealInfo.date, menuInfos: mealInfo.menuInfos, mode: currentMode, highlightedUuids: viewModel.highlightedUuids)
            
            card.onMenuHighlightChanged = { [weak self] uuid, isSelected in
                self?.viewModel.syncHighlightStatus(uuid: uuid, status: isSelected)
            }
            
            card.snp.makeConstraints { make in
                make.top.bottom.leading.trailing.equalToSuperview().inset(12)
            }
        }
    }
    
    private func scrollToToday(animated: Bool) {
        let todayIndex = viewModel.getTodayIndex()
        let pageWidth = pagingScrollView.frame.width
        
        if pageWidth > 0 {
            let offset = CGPoint(x: CGFloat(todayIndex) * pageWidth, y: 0)
            pagingScrollView.setContentOffset(offset, animated: animated)
        }
    }
    
    @objc private func menuTapped() {
        onMenuButtonTapped?()
    }
}

#Preview {
    return HomeViewController()
}
