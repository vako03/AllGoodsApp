//
//  RegisterViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//

import UIKit

final class RegisterViewController: UIViewController {
    var coordinator: AppCoordinator?
    private let viewModel = AuthViewModel()

    private let logoImageView = UIImageView(image: UIImage(named: "allgoodsapp"))
    private let titleLabel = CustomLabel(text: "Register", fontSize: 28, alignment: .left)
    private let loader = CustomLoader()

    private lazy var usernameTextField: CustomTextField = {
        let textField = CustomTextField(
            placeholder: "Enter your username",
            rightIconImage: UIImage(systemName: "checkmark.circle"),
            onTextChange: { [weak self] text in
                guard let self = self else { return }
                CustomTextFieldHandlers.handleEmailTextChange(textField: self.usernameTextField, text: text)
            }
        )
        textField.inputAccessoryView = createToolbar()
        return textField
    }()

    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(
            placeholder: "Enter your email",
            rightIconImage: UIImage(systemName: "checkmark.circle"),
            onTextChange: { [weak self] text in
                guard let self = self else { return }
                CustomTextFieldHandlers.handleEmailTextChange(textField: self.emailTextField, text: text)
            }
        )
        textField.inputAccessoryView = createToolbar()
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
        textField.textContentType = .oneTimeCode // Disable strong password suggestion
        textField.inputAccessoryView = createToolbar()
        return textField
    }()

    private let termsCheckmark = UIButton(type: .custom)
    private let termsLabel = CustomLabel(text: "I agree to the terms and conditions")
    private lazy var registerButton = CustomButton(title: "Register") { [weak self] in
        self?.handleRegisterTapped()
    }

    private var termsAccepted = false {
        didSet {
            updateRegisterButtonState()
        }
    }

    private var allFieldsValid: Bool {
        return !(usernameTextField.text?.isEmpty ?? true) &&
               isValidEmail(emailTextField.text ?? "") &&
               !(passwordTextField.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
        updateRegisterButtonState()
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
        termsCheckmark.addAction(UIAction { [weak self] _ in
            self?.showTermsAndConditions()
        }, for: .touchUpInside)
    }

    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flexSpace, doneButton]
        return toolbar
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func handleRegisterTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(on: self, message: "Please ensure all fields are filled out correctly.")
            return
        }

        loader.startLoading(in: view)

        viewModel.register(email: email, password: password, username: username) { [weak self] result in
            guard let self = self else { return }
            self.loader.stopLoading()
            switch result {
            case .success:
                self.showSuccessAlert()
            case .failure(let error):
                showAlert(on: self, message: error.localizedDescription)
            }
        }
    }

    private func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Registration successful. Please log in.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.coordinator?.showLogin()
        }))
        present(alertController, animated: true, completion: nil)
    }

    private func updateRegisterButtonState() {
        registerButton.isEnabled = termsAccepted && allFieldsValid
    }

    private func showTermsAndConditions() {
        let termsVC = TermsViewController()
        termsVC.modalPresentationStyle = .formSheet
        termsVC.delegate = self
        present(termsVC, animated: true, completion: nil)
    }
}

extension RegisterViewController: TermsViewControllerDelegate {
    func didAcceptTerms() {
        termsAccepted = true
        termsCheckmark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        updateRegisterButtonState()
    }
}
