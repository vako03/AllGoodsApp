//
//  AppCoordinator.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit
import FirebaseAuth

class AppCoordinator {
    var window: UIWindow
    var navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }

    func start() {
        if Auth.auth().currentUser != nil {
            showMainPage()
        } else if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
            showLogin()
        } else {
            showOnboarding()
        }
    }

    func showOnboarding() {
        let onboardingVC = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        onboardingVC.coordinator = self
        navigationController.setViewControllers([onboardingVC], animated: true)
    }

    func showLogin() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: true)
    }

    func showRegister() {
        let registerVC = RegisterViewController()
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }

    func showMainPage() {
        let mainVC = MainViewController()
        mainVC.coordinator = self
        navigationController.setViewControllers([mainVC], animated: true)
    }
}
