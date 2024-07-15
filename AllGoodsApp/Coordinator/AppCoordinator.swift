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
    private let viewModel = ProductViewModel()

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()

        // Load data from Firestore
        SharedStorage.shared.loadFavoritesFromFirestore()
        SharedStorage.shared.loadCartFromFirestore()
    }

    func start() {
        if AuthViewModel().isLoggedIn {
            let username = Auth.auth().currentUser?.displayName ?? "Guest"
            showMainTabBar(username: username)
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

    func showMainTabBar(username: String) {
        let tabBarVC = CustomTabBarController()

        let mainVC = MainViewController()
        mainVC.coordinator = self
        mainVC.username = username

        let favouriteVC = FavouriteViewController()
        favouriteVC.coordinator = self
        
        let expressVC = ExpressViewController(viewModel: viewModel) // Pass viewModel here
        expressVC.coordinator = self

        let basketVC = BasketViewController()
        basketVC.coordinator = self

        let profileVC = ProfileViewController()
        profileVC.coordinator = self
        profileVC.username = username

        mainVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), tag: 0)
        favouriteVC.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart"), tag: 1)
        expressVC.tabBarItem = UITabBarItem(title: "", image: nil, tag: 2)
        basketVC.tabBarItem = UITabBarItem(title: "Basket", image: UIImage(systemName: "cart"), tag: 3)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)

        tabBarVC.viewControllers = [mainVC, favouriteVC, expressVC, basketVC, profileVC]
        
        tabBarVC.setValue(CustomTabBar(), forKey: "tabBar")

        navigationController.setViewControllers([tabBarVC], animated: true)
    }
}
