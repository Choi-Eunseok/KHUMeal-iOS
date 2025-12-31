//
//  SplashViewController.swift
//  Meal
//

import UIKit
import SnapKit
import FirebaseMessaging

class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "LaunchIcon")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.alpha = 0
        setupUI()
        requestUserCreateOrUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.logoImageView.alpha = 1
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .mainRed
        
        view.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
        }
    }
    
    private func requestUserCreateOrUpdate() {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown_ID"
        let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") ?? Messaging.messaging().fcmToken ?? ""
        UserDefaults.standard.set(deviceID, forKey: "userId")
        
        print("사용자 동기화 요청 (ID: \(deviceID), Token: \(fcmToken))")
        
        Task {
            let startTime = Date()
            
            do {
                try await UserService.shared.syncUser(deviceID: deviceID, fcmToken: fcmToken)
                print("사용자 동기화 완료")
            } catch {
                print("오류 발생: \(error)")
            }
            let elapsed = Date().timeIntervalSince(startTime)
            let minimumDisplayTime: TimeInterval = 1.5
            
            if elapsed < minimumDisplayTime {
                let delay = UInt64((minimumDisplayTime - elapsed) * 1_000_000_000)
                try? await Task.sleep(nanoseconds: delay)
            }
            
            await MainActor.run {
                self.navigateToHome()
            }
        }
    }
    
    private func navigateToHome() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else { return }
        
        let mainContainerVC = MainContainerViewController()
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            window.rootViewController = mainContainerVC
            window.makeKeyAndVisible()
        }, completion: nil)
    }
}
