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
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "allgoodsapp")
        imageView.contentMode = .scaleAspectFit
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
        
        textField.rightView = usernameCheckmark
        textField.rightViewMode = .always
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
        imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
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
        
        textField.rightView = emailCheckmark
        textField.rightViewMode = .always
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
        imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
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
        
        textField.rightView = passwordToggle
        textField.rightViewMode = .always
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
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        return button
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "I agree to the terms and conditions"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var termsCheckmark: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showTermsAndConditions), for: .touchUpInside)
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
        let usernameStack = UIStackView(arrangedSubviews: [usernameLabel, usernameTextField, usernameUnderline])
        usernameStack.axis = .vertical
        usernameStack.spacing = 4
        usernameStack.translatesAutoresizingMaskIntoConstraints = false
        
        let emailStack = UIStackView(arrangedSubviews: [emailLabel, emailTextField, emailUnderline])
        emailStack.axis = .vertical
        emailStack.spacing = 4
        emailStack.translatesAutoresizingMaskIntoConstraints = false
        
        let passwordStack = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField, passwordUnderline])
        passwordStack.axis = .vertical
        passwordStack.spacing = 4
        passwordStack.translatesAutoresizingMaskIntoConstraints = false
        
        let termsStack = UIStackView(arrangedSubviews: [termsCheckmark, termsLabel])
        termsStack.axis = .horizontal
        termsStack.spacing = 3
        termsStack.alignment = .center
        termsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView(arrangedSubviews: [logoImageView, titleLabel, usernameStack, emailStack, passwordStack])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.alignment = .fill
        mainStack.distribution = .equalSpacing
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStack)
        view.addSubview(registerButton)
        view.addSubview(termsStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameTextField.heightAnchor.constraint(equalToConstant: 30),
            usernameUnderline.heightAnchor.constraint(equalToConstant: 1),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 30),
            emailUnderline.heightAnchor.constraint(equalToConstant: 1),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 30),
            passwordUnderline.heightAnchor.constraint(equalToConstant: 1),
            
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
        passwordToggle.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
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
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordToggle.setImage(UIImage(systemName: imageName), for: .normal)
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
                  showAlert(message: "Please ensure all fields are filled out correctly.")
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
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
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
