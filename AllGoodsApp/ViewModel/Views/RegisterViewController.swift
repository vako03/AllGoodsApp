//
//  RegisterViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//

import UIKit

class RegisterViewController: UIViewController {
    var coordinator: AppCoordinator?
    private let viewModel = AuthViewModel()

    private let logoImageView = UIImageView(image: UIImage(named: "allgoodsapp"))
    private let titleLabel = CustomLabel(text: "Register", fontSize: 28, alignment: .left)
    private let usernameTextField = CustomTextField(placeholder: "Enter your username", rightIconImage: UIImage(systemName: "checkmark.circle"))
    private let emailTextField = CustomTextField(placeholder: "Enter your email", rightIconImage: UIImage(systemName: "checkmark.circle"))
    private let passwordTextField = CustomTextField(placeholder: "Enter your password", isSecure: true, rightIconImage: UIImage(systemName: "eye.slash"))
    private let termsCheckmark = UIButton(type: .custom)
    private let termsLabel = CustomLabel(text: "I agree to the terms and conditions")
    private let registerButton = CustomButton(title: "Register")

    private var termsAccepted = false {
        didSet {
            registerButton.isEnabled = termsAccepted
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }

    private func setupUI() {
        termsCheckmark.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        termsCheckmark.tintColor = .black
        termsCheckmark.translatesAutoresizingMaskIntoConstraints = false

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true

        let usernameStack = CustomStack(arrangedSubviews: [CustomLabel(text: "Username"), usernameTextField], axis: .vertical)
        let emailStack = CustomStack(arrangedSubviews: [CustomLabel(text: "Email"), emailTextField], axis: .vertical)
        let passwordStack = CustomStack(arrangedSubviews: [CustomLabel(text: "Password"), passwordTextField], axis: .vertical)
        let termsStack = CustomStack(arrangedSubviews: [termsCheckmark, termsLabel], axis: .horizontal, spacing: 3, alignment: .center)
        let mainStack = CustomStack(arrangedSubviews: [logoImageView, titleLabel, usernameStack, emailStack, passwordStack], axis: .vertical, spacing: 16)

        view.addSubview(mainStack)
        view.addSubview(registerButton)
        view.addSubview(termsStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            registerButton.bottomAnchor.constraint(equalTo: termsStack.topAnchor, constant: -10),

            termsStack.heightAnchor.constraint(equalToConstant: 30),
            termsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupActions() {
        usernameTextField.addTarget(self, action: #selector(usernameTextChanged(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailTextChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextChanged(_:)), for: .editingChanged)
        passwordTextField.rightIconButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        termsCheckmark.addTarget(self, action: #selector(showTermsAndConditions), for: .touchUpInside)
    }

    @objc private func usernameTextChanged(_ textField: UITextField) {
        usernameTextField.rightIconButton.isHidden = textField.text?.isEmpty ?? true
    }

    @objc private func emailTextChanged(_ textField: UITextField) {
        emailTextField.rightIconButton.isHidden = !isValidEmail(textField.text ?? "")
    }

    @objc private func passwordTextChanged(_ textField: UITextField) {
        passwordTextField.rightIconButton.isHidden = textField.text?.isEmpty ?? true
    }

    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordTextField.rightIconButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func showTermsAndConditions() {
        let termsVC = TermsViewController()
        termsVC.modalPresentationStyle = .formSheet
        termsVC.delegate = self
        present(termsVC, animated: true, completion: nil)
    }

    @objc private func registerTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  showAlert(on: self, message: "Please ensure all fields are filled out correctly.")
                  return
              }

        viewModel.register(email: email, password: password, username: username) { [weak self] result in
            switch result {
            case .success:
                self?.showSuccessAlert()
            case .failure(let error):
                showAlert(on: self!, message: error.localizedDescription)
            }
        }
    }

    private func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Registration successful. Please log in.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            self?.coordinator?.showLogin()
        }))
        present(alertController, animated: true, completion: nil)
    }
}

extension RegisterViewController: TermsViewControllerDelegate {
    func didAcceptTerms() {
        termsAccepted = true
        termsCheckmark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        registerButton.isEnabled = true
    }
}
