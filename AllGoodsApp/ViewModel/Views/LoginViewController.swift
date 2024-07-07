//
//  LoginViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit

final class LoginViewController: UIViewController {
    var coordinator: AppCoordinator?
    private let viewModel = AuthViewModel()

    private let logoImageView = UIImageView(image: UIImage(named: "allgoodsapp"))
    private let titleLabel = CustomLabel(text: "Welcome", fontSize: 28, alignment: .left)
    private let descriptionLabel = CustomLabel(text: "Log in, sign up, or continue as a guest.", fontSize: 16, textColor: .gray, alignment: .left)
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(
            placeholder: "Enter your email",
            rightIconImage: UIImage(systemName: "checkmark.circle"),
            onTextChange: { [weak self] text in
                guard let self = self else { return }
                CustomTextFieldHandlers.handleEmailTextChange(textField: self.emailTextField, text: text)
            }
        )
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(
            placeholder: "Enter your password",
            isSecure: true,
            rightIconImage: UIImage(systemName: "eye.slash"),
            onTextChange: { [weak self] text in
                guard let self = self else { return }
                CustomTextFieldHandlers.handlePasswordTextChange(textField: self.passwordTextField, text: text)
            },
            onIconTap: { [weak self] in
                guard let self = self else { return }
                CustomTextFieldHandlers.togglePasswordVisibility(textField: self.passwordTextField)
            }
        )
        return textField
    }()
    
    private lazy var loginButton = CustomButton(title: "Login") { [weak self] in
        self?.handleLoginTapped()
    }
    
    private lazy var registerButton = CustomButton(title: "Register") { [weak self] in
        self?.coordinator?.showRegister()
    }
    
    private lazy var guestButton = CustomButton(title: "Continue as Guest") { [weak self] in
        self?.coordinator?.showMainPage(username: "Guest")
    }
    
    private let orLabel = CustomLabel(text: "or", alignment: .center)

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

    private func handleLoginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(on: self, message: "Please enter a valid email and password.")
            return
        }

        viewModel.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userModel):
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.coordinator?.showMainPage(username: userModel.username)
            case .failure(let error):
                showAlert(on: self, message: error.localizedDescription)
            }
        }
    }
}
