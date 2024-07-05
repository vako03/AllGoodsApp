//
//  MainViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    var coordinator: AppCoordinator?
    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let label = UILabel()
        label.text = "Welcome, \(username ?? "Guest")"
        label.textAlignment = .center
        view.addSubview(label)
        
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        view.addSubview(logoutButton)

        label.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20)
        ])
    }

    @objc private func logoutTapped() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            coordinator?.showLogin()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
