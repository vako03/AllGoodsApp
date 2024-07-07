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

    private let logoImageView = UIImageView(image: UIImage(named: "allgoodsapp"))
    private let titleLabel = CustomLabel(text: "Welcome", fontSize: 28, alignment: .left)
    private let descriptionLabel = CustomLabel(text: "Log in, sign up, or continue as a guest.", fontSize: 16, textColor: .gray, alignment: .left)
    private let emailTextField = CustomTextField(placeholder: "Enter your email", rightIconImage: UIImage(systemName: "checkmark.circle"))
    private let passwordTextField = CustomTextField(placeholder: "Enter your password", isSecure: true, rightIconImage: UIImage(systemName: "eye.slash"))
    private let loginButton = CustomButton(title: "Login")
    private let registerButton = CustomButton(title: "Register")
    private let guestButton = CustomButton(title: "Continue as Guest")
    private let orLabel = CustomLabel(text: "or", alignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
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
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true

        let emailStack = CustomStack(arrangedSubviews: [CustomLabel(text: "Email"), emailTextField], axis: .vertical)
        let passwordStack = CustomStack(arrangedSubviews: [CustomLabel(text: "Password"), passwordTextField], axis: .vertical)
        let buttonStack = CustomStack(arrangedSubviews: [loginButton, orLabel, registerButton, guestButton], axis: .vertical, spacing: 16)
        let mainStack = CustomStack(arrangedSubviews: [logoImageView, titleLabel, descriptionLabel, emailStack, passwordStack], axis: .vertical, spacing: 16)

        view.addSubview(mainStack)
        view.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupActions() {
        emailTextField.addTarget(self, action: #selector(emailTextChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextChanged(_:)), for: .editingChanged)
        passwordTextField.rightIconButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(guestTapped), for: .touchUpInside)
    }

    @objc private func emailTextChanged(_ textField: UITextField) {
        if let email = textField.text, isValidEmail(email) {
            emailTextField.rightIconButton.isHidden = false
        } else {
            emailTextField.rightIconButton.isHidden = true
        }
    }

    @objc private func passwordTextChanged(_ textField: UITextField) {
        if !textField.text!.isEmpty {
            passwordTextField.rightIconButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }

    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordTextField.rightIconButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  showAlert(on: self, message: "Please enter a valid email and password.")
                  return
              }

        viewModel.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let userModel):
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self?.coordinator?.showMainPage(username: userModel.username)
            case .failure(let error):
                showAlert(on: self!, message: error.localizedDescription)
            }
        }
    }

    @objc private func registerTapped() {
        coordinator?.showRegister()
    }

    @objc private func guestTapped() {
        coordinator?.showMainPage(username: "Guest")
    }
}
