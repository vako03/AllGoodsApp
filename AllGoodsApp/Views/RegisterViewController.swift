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

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "allgoodsapp")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Create an account to enjoy all the services."
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your username"
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(usernameTextChanged(_:)), for: .editingChanged)
        return textField
    }()

    private let usernameUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let usernameCheckmark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your email"
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(emailTextChanged(_:)), for: .editingChanged)
        return textField
    }()

    private let emailUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let emailCheckmark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your password"
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(passwordTextChanged(_:)), for: .editingChanged)
        return textField
    }()

    private let passwordUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var passwordToggle: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        return button
    }()

    private let confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Password"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm your password"
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(confirmPasswordTextChanged(_:)), for: .editingChanged)
        return textField
    }()

    private let confirmPasswordUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var confirmPasswordToggle: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        return button
    }()

    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()

    private lazy var termsCheckmark: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showTermsAndConditions), for: .touchUpInside)
        return button
    }()

    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "By joining, you agree to comply with our Terms and Conditions."
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var termsAccepted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }

    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(usernameUnderline)
        view.addSubview(usernameCheckmark)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailUnderline)
        view.addSubview(emailCheckmark)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordUnderline)
        view.addSubview(passwordToggle)
        view.addSubview(confirmPasswordLabel)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(confirmPasswordUnderline)
        view.addSubview(confirmPasswordToggle)
        view.addSubview(registerButton)
        view.addSubview(termsCheckmark)
        view.addSubview(termsLabel)

        NSLayoutConstraint.activate([
            // Logo ImageView Constraints
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),

            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),

            // Description Label Constraints
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            // Username Label Constraints
            usernameLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            // Username TextField Constraints
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 30),

            // Username Underline Constraints
            usernameUnderline.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 4),
            usernameUnderline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            usernameUnderline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            usernameUnderline.heightAnchor.constraint(equalToConstant: 1),

            // Username Checkmark Constraints
            usernameCheckmark.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor),
            usernameCheckmark.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            usernameCheckmark.widthAnchor.constraint(equalToConstant: 20),
            usernameCheckmark.heightAnchor.constraint(equalToConstant: 20),

            // Email Label Constraints
            emailLabel.topAnchor.constraint(equalTo: usernameUnderline.bottomAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            // Email TextField Constraints
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 30),

            // Email Underline Constraints
            emailUnderline.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 4),
            emailUnderline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailUnderline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailUnderline.heightAnchor.constraint(equalToConstant: 1),

            // Email Checkmark Constraints
            emailCheckmark.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor),
            emailCheckmark.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailCheckmark.widthAnchor.constraint(equalToConstant: 20),
            emailCheckmark.heightAnchor.constraint(equalToConstant: 20),

            // Password Label Constraints
            passwordLabel.topAnchor.constraint(equalTo: emailUnderline.bottomAnchor, constant: 16),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            // Password TextField Constraints
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30),

            // Password Underline Constraints
            passwordUnderline.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4),
            passwordUnderline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordUnderline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordUnderline.heightAnchor.constraint(equalToConstant: 1),

            // Password Toggle Constraints
            passwordToggle.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            passwordToggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordToggle.widthAnchor.constraint(equalToConstant: 20),
            passwordToggle.heightAnchor.constraint(equalToConstant: 20),

            // Confirm Password Label Constraints
            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordUnderline.bottomAnchor, constant: 16),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            confirmPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            // Confirm Password TextField Constraints
            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 8),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 30),

            // Confirm Password Underline Constraints
            confirmPasswordUnderline.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 4),
            confirmPasswordUnderline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            confirmPasswordUnderline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            confirmPasswordUnderline.heightAnchor.constraint(equalToConstant: 1),

            // Confirm Password Toggle Constraints
            confirmPasswordToggle.centerYAnchor.constraint(equalTo: confirmPasswordTextField.centerYAnchor),
            confirmPasswordToggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            confirmPasswordToggle.widthAnchor.constraint(equalToConstant: 20),
            confirmPasswordToggle.heightAnchor.constraint(equalToConstant: 20),

            // Register Button Constraints
            registerButton.topAnchor.constraint(equalTo: confirmPasswordUnderline.bottomAnchor, constant: 40),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            registerButton.heightAnchor.constraint(equalToConstant: 50),

            // Terms Checkmark Constraints
            termsCheckmark.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16),
            termsCheckmark.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            termsCheckmark.widthAnchor.constraint(equalToConstant: 20),
            termsCheckmark.heightAnchor.constraint(equalToConstant: 20),

            // Terms Label Constraints
            termsLabel.centerYAnchor.constraint(equalTo: termsCheckmark.centerYAnchor),
            termsLabel.leadingAnchor.constraint(equalTo: termsCheckmark.trailingAnchor, constant: 8),
            termsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }

    private func setupActions() {
        usernameTextField.addTarget(self, action: #selector(usernameTextChanged(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailTextChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextChanged(_:)), for: .editingChanged)
        passwordToggle.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        confirmPasswordTextField.addTarget(self, action: #selector(confirmPasswordTextChanged(_:)), for: .editingChanged)
        confirmPasswordToggle.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        termsCheckmark.addTarget(self, action: #selector(showTermsAndConditions), for: .touchUpInside)
    }

    @objc private func usernameTextChanged(_ textField: UITextField) {
        if let username = textField.text, !username.isEmpty {
            usernameCheckmark.isHidden = false
        } else {
            usernameCheckmark.isHidden = true
        }
    }

    @objc private func emailTextChanged(_ textField: UITextField) {
        if let email = textField.text, isValidEmail(email) {
            emailCheckmark.isHidden = false
        } else {
            emailCheckmark.isHidden = true
        }
    }

    @objc private func passwordTextChanged(_ textField: UITextField) {
        if !textField.text!.isEmpty {
            passwordToggle.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }

    @objc private func confirmPasswordTextChanged(_ textField: UITextField) {
        if !textField.text!.isEmpty {
            confirmPasswordToggle.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            confirmPasswordTextField.isSecureTextEntry = true
        }
    }

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        if sender == passwordToggle {
            passwordTextField.isSecureTextEntry.toggle()
            let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
            passwordToggle.setImage(UIImage(systemName: imageName), for: .normal)
        } else if sender == confirmPasswordToggle {
            confirmPasswordTextField.isSecureTextEntry.toggle()
            let imageName = confirmPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
            confirmPasswordToggle.setImage(UIImage(systemName: imageName), for: .normal)
        }
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
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty,
              password == confirmPassword else {
                  showAlert(message: "Please ensure all fields are filled out correctly and passwords match.")
                  return
              }

        viewModel.register(email: email, password: password, username: username) { [weak self] result in
            switch result {
            case .success:
                self?.showSuccessAlert()
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

    private func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Registration successful. Please log in.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.coordinator?.showLogin()
        }))
        present(alertController, animated: true, completion: nil)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension RegisterViewController: TermsViewControllerDelegate {
    func didAcceptTerms() {
        termsAccepted = true
        termsCheckmark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        registerButton.isEnabled = true
    }
}
