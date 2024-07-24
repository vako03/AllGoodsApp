//
//  ProfileViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 09.07.24.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    var coordinator: AppCoordinator?
    var username: String?

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var cartView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGreen
        view.layer.cornerRadius = 8
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCartTapped)))
        view.addSubview(cartLabel)
        return view
    }()

    private lazy var cartLabel: UILabel = {
        let label = UILabel()
        label.text = "View shopping cart"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var ordersButton: CustomButton = {
        let button = CustomButton(title: "My orders") { [weak self] in
            self?.handleOrdersTapped()
        }
        return button
    }()

    private lazy var wishlistButton: CustomButton = {
        let button = CustomButton(title: "Wishlist") { [weak self] in
            self?.handleWishlistTapped()
        }
        return button
    }()

    private lazy var privacyTermsButton: CustomButton = {
        let button = CustomButton(title: "Privacy & Terms") { [weak self] in
            self?.handlePrivacyTermsTapped()
        }
        return button
    }()

    private lazy var logoutButton: CustomButton = {
        let button = CustomButton(title: isLoggedIn ? "Log out" : "Log in") { [weak self] in
            self?.handleLogoutTapped()
        }
        return button
    }()

    private lazy var contactInfoLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Contact Information:
        Address: Tbilisi, 0163, Main Street
        Phone: 032 2 123 123
        Email: contact.allgoodsapp@gmail.com
        """
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ordersButton, wishlistButton, privacyTermsButton, logoutButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Profile"
        setupViews()
        updateLogoutButtonTitle()
    }

    // MARK: - Setup Views
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(cartView)
        contentView.addSubview(buttonStackView)
        contentView.addSubview(contactInfoLabel)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        cartView.translatesAutoresizingMaskIntoConstraints = false
        cartLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contactInfoLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            profileImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            cartView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            cartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cartView.heightAnchor.constraint(equalToConstant: 50),

            cartLabel.centerXAnchor.constraint(equalTo: cartView.centerXAnchor),
            cartLabel.centerYAnchor.constraint(equalTo: cartView.centerYAnchor),

            buttonStackView.topAnchor.constraint(equalTo: cartView.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            contactInfoLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
            contactInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Update UI
    private func updateLogoutButtonTitle() {
        let newTitle = isLoggedIn ? "Log out" : "Log in"
        logoutButton.setTitle(newTitle, for: .normal)
    }

    // MARK: - Auth
    private var isLoggedIn: Bool {
        return AuthViewModel().isLoggedIn
    }

    private func handleOrdersTapped() {
        let myOrderVC = OrderViewController()
        navigationController?.pushViewController(myOrderVC, animated: true)
    }

    private func handleWishlistTapped() {
        guard let tabBarVC = coordinator?.navigationController.viewControllers.first as? UITabBarController else { return }
        tabBarVC.selectedIndex = 1
    }

    private func handlePrivacyTermsTapped() {
        let privacyTermsVC = PrivacyTermsViewController()
        privacyTermsVC.modalPresentationStyle = .formSheet
        present(privacyTermsVC, animated: true, completion: nil)
    }

    @objc private func handleCartTapped() {
        guard let tabBarVC = coordinator?.navigationController.viewControllers.first as? UITabBarController else { return }
        tabBarVC.selectedIndex = 3
    }

    private func handleLogoutTapped() {
        AuthViewModel().logout { [weak self] result in
            switch result {
            case .success:
                self?.coordinator?.showLogin()
                self?.updateLogoutButtonTitle()
            case .failure(let error):
                showAlert(on: self!, message: error.localizedDescription)
            }
        }
    }
}
