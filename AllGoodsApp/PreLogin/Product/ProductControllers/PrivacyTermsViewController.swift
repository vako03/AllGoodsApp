//
//  PrivacyTermsViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 24.07.24.
//

import UIKit

class PrivacyTermsViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        return textView
    }()
    
    // MARK: - Properties
    private let viewModel: PrivacyTermsViewModel

    // MARK: - Initializers
    init(viewModel: PrivacyTermsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Privacy & Terms"
        setupViews()
        configureTextView()
    }

    // MARK: - Setup Views
    private func setupViews() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Configure TextView
    private func configureTextView() {
        textView.text = viewModel.privacyTermsText
    }
}
