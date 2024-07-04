//
//  RegisterViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    var coordinator: AppCoordinator?
    private let viewModel = AuthViewModel()

    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let registerButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.isSecureTextEntry = true
        registerButton.setTitle("Register", for: .normal)

        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, confirmPasswordTextField, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }

    @objc private func registerTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty,
              password == confirmPassword else {
                  showAlert(message: "Please ensure all fields are filled out correctly and passwords match.")
                  return
              }

        viewModel.register(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.coordinator?.showMainPage()
            case .failure(let error):
                print("Failed to register: \(error.localizedDescription)")
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
