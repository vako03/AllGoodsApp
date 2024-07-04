//
//  LoginViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit

class LoginViewController: UIViewController {
    var coordinator: AppCoordinator?
    private let viewModel = AuthViewModel()

    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)
    private let guestButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    private func setupUI() {
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        loginButton.setTitle("Login", for: .normal)
        registerButton.setTitle("Register", for: .normal)
        guestButton.setTitle("Continue as Guest", for: .normal)

        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(guestTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, registerButton, guestButton])
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }

    @objc private func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  showAlert(message: "Please enter a valid email and password.")
                  return
              }

        viewModel.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.coordinator?.showMainPage()
            case .failure(let error):
                print("Failed to login: \(error.localizedDescription)")
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }

    @objc private func registerTapped() {
        coordinator?.showRegister()
    }

    @objc private func guestTapped() {
        coordinator?.showMainPage()
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
