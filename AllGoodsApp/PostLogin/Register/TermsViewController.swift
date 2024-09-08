//
//  TermsViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 05.07.24.
//

import UIKit

protocol TermsViewControllerDelegate: AnyObject {
    func didAcceptTerms()
}

final class TermsViewController: UIViewController, UITextViewDelegate {
    weak var delegate: TermsViewControllerDelegate?
    private let viewModel = TermsViewModel()

    // MARK: - UI Elements
    private let termsTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var acceptButton = CustomButton(title: "Accept") { [weak self] in
        self?.acceptTapped()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindData()
        termsTextView.delegate = self
        acceptButton.isEnabled = false
    }

    // MARK: - Bind Data
    private func bindData() {
        termsTextView.text = viewModel.termsAndConditionsText 
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(termsTextView)
        view.addSubview(acceptButton)

        NSLayoutConstraint.activate([
            termsTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            termsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            termsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            termsTextView.bottomAnchor.constraint(equalTo: acceptButton.topAnchor, constant: -20),

            acceptButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            acceptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            acceptButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Actions
    private func acceptTapped() {
        delegate?.didAcceptTerms()
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITextViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            acceptButton.isEnabled = true
        }
    }
}
