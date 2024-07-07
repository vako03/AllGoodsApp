//
//  MainViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit

final class MainViewController: UIViewController {
    var coordinator: AppCoordinator?
    var username: String?

    private let welcomeLabel = CustomLabel(text: "", fontSize: 24, alignment: .center)
    private lazy var logoutButton = CustomButton(title: "Logout") { [weak self] in
        self?.handleLogoutTapped()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(logoutButton)

        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            logoutButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        if let username = username {
            welcomeLabel.text = "Welcome, \(username)"
        }
    }

    private func handleLogoutTapped() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        coordinator?.showLogin()
    }
}
