//
//  ProfileViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 09.07.24.
//

import UIKit

class ProfileViewController: UIViewController {
    var coordinator: AppCoordinator?
    var username: String?

    private lazy var favouriteButton: CustomButton = {
        let button = CustomButton(title: "Favourite") { [weak self] in
            self?.handleFavouriteTapped()
        }
        return button
    }()

    private lazy var cartButton: CustomButton = {
        let button = CustomButton(title: "Cart") { [weak self] in
            self?.handleCartTapped()
        }
        return button
    }()

    private lazy var ordersButton: CustomButton = {
        let button = CustomButton(title: "Orders") { [weak self] in
            self?.handleOrdersTapped()
        }
        return button
    }()

    private lazy var logoutButton: CustomButton = {
        let button = CustomButton(title: "Log out") { [weak self] in
            self?.handleLogoutTapped()
        }
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favouriteButton, cartButton, ordersButton, logoutButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Profile"
        setupViews()
    }

    private func setupViews() {
        view.addSubview(buttonStackView)

        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func handleFavouriteTapped() {
        guard let tabBarVC = coordinator?.navigationController.viewControllers.first as? UITabBarController else { return }
        tabBarVC.selectedIndex = 1 // Assuming FavouriteViewController is at index 1
    }

    private func handleCartTapped() {
        guard let tabBarVC = coordinator?.navigationController.viewControllers.first as? UITabBarController else { return }
        tabBarVC.selectedIndex = 3 // Assuming BasketViewController is at index 3
    }

    private func handleOrdersTapped() {
        let myOrderVC = OrderViewController()
        navigationController?.pushViewController(myOrderVC, animated: true)
    }

    private func handleLogoutTapped() {
        AuthViewModel().logout { [weak self] result in
            switch result {
            case .success:
                self?.coordinator?.showLogin()
            case .failure(let error):
                showAlert(on: self!, message: error.localizedDescription)
            }
        }
    }
}
