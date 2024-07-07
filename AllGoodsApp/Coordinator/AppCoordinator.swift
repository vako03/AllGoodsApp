//
//  AppCoordinator.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit
import FirebaseAuth

final class AppCoordinator {
    var window: UIWindow
    var navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }

    func start() {
        if AuthViewModel().isLoggedIn {
            let username = Auth.auth().currentUser?.displayName ?? "Guest"
            showMainPage(username: username)
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

    func showMainPage(username: String) {
        let mainVC = MainViewController()
        mainVC.coordinator = self
        mainVC.username = username
        navigationController.setViewControllers([mainVC], animated: true)
    }
}
