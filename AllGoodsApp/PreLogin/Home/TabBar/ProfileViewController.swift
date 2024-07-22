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

    private let nameLabel = CustomLabel(text: "", fontSize: 24, alignment: .center)

    private lazy var authorizationButton: CustomButton = {
        let button = CustomButton(title: "Authorization") { [weak self] in
            self?.handleAuthorizationTapped()
        }
        return button
    }()

    private lazy var logoutButton: CustomButton = {
        let button = CustomButton(title: "Logout") { [weak self] in
            self?.handleLogoutTapped()
        }
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Profile"
        setupUI()
    }

    private func setupUI() {
        view.addSubview(nameLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])

        if let username = username {
            nameLabel.text = "Hi, \(username)"
            if username == "Guest" {
                view.addSubview(authorizationButton)
                authorizationButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    authorizationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    authorizationButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20)
                ])
            } else {
                view.addSubview(logoutButton)
                logoutButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    logoutButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20)
                ])
            }
        }
    }

    private func handleAuthorizationTapped() {
        coordinator?.showLogin()
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
