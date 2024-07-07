//
//  MainViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit

class MainViewController: UIViewController {
    var coordinator: AppCoordinator?
    var username: String?

    private let welcomeLabel = CustomLabel(text: "", fontSize: 24, alignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        view.addSubview(welcomeLabel)

        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        if let username = username {
            welcomeLabel.text = "Welcome, \(username)"
        }
    }
}
