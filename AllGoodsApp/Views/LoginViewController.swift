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

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "allgoodsapp")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in, sign up, or continue as a guest."
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()

    private let loginButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)
    private let guestButton = UIButton(type: .system)

    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        configureButton(loginButton, title: "Login")
        configureButton(registerButton, title: "Register")
        configureButton(guestButton, title: "Continue as Guest")

        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailUnderline)
        view.addSubview(emailCheckmark)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordUnderline)
        view.addSubview(passwordToggle)
        view.addSubview(loginButton)
        view.addSubview(orLabel)
        view.addSubview(registerButton)
        view.addSubview(guestButton)

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

            // Email Label Constraints
            emailLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
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

            // Login Button Constraints
            loginButton.topAnchor.constraint(equalTo: passwordUnderline.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            // Or Label Constraints
            orLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Register Button Constraints
            registerButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 16),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            registerButton.heightAnchor.constraint(equalToConstant: 50),

            // Guest Button Constraints
            guestButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16),
            guestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            guestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            guestButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupActions() {
        emailTextField.addTarget(self, action: #selector(emailTextChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextChanged(_:)), for: .editingChanged)
        passwordToggle.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(guestTapped), for: .touchUpInside)
    }

    private func configureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc private func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  showAlert(message: "Please enter a valid email and password.")
                  return
              }

        viewModel.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let userModel):
                self?.coordinator?.showMainPage(username: userModel.username)
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }


    @objc private func registerTapped() {
        coordinator?.showRegister()
    }

    @objc private func guestTapped() {
        coordinator?.showMainPage(username: "Guest")
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
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

    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordToggle.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
