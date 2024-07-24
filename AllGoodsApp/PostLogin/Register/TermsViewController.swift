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

    // MARK: - UI Elements
    private let termsTextView: UITextView = {
        let textView = UITextView()
        textView.text = """
        Terms and Conditions

        Welcome to AllGoodsApp! These terms and conditions ("Terms") govern your access to and use of the AllGoodsApp mobile application (the "App"), operated by AllGoodsApp Inc. ("AllGoodsApp", "we", "us", or "our"). By accessing or using the App, you agree to be bound by these Terms. If you disagree with any part of these Terms, you may not access the App.

        1. Acceptance of Terms

        By using AllGoodsApp, you agree to comply with and be legally bound by these Terms, whether or not you become a registered user. These Terms govern your access to and use of the App and constitute a binding legal agreement between you and AllGoodsApp.

        2. Use of the App

        2.1. License: Subject to these Terms, AllGoodsApp grants you a limited, non-exclusive, non-transferable, and revocable license to use the App for your personal, non-commercial use.

        2.2. Restrictions: You agree not to (a) modify, adapt, translate, or reverse engineer any portion of the App; (b) use the App for any illegal purpose or in violation of any local, state, national, or international law; (c) violate or encourage others to violate any right of or obligation to a third party, including by infringing, misappropriating, or violating intellectual property, confidentiality, or privacy rights.

        3. Privacy Policy

        Your use of the App is also governed by our Privacy Policy, which is incorporated into these Terms by reference. Please review our Privacy Policy to understand our practices.

        4. User Content

        4.1. Posting Content: You may be able to post content, including reviews, comments, and photos ("User Content"), on the App. By posting User Content, you represent and warrant that you have the right to post that content and that it does not violate these Terms.

        4.2. Ownership of User Content: You retain ownership of your User Content. By posting User Content on the App, you grant AllGoodsApp a non-exclusive, transferable, sublicensable, royalty-free, worldwide license to use, store, display, reproduce, modify, create derivative works, perform, and distribute your User Content on the App solely for the purposes of operating, developing, providing, and improving the App.

        5. Intellectual Property

        5.1. Ownership: All intellectual property rights in the App and its content (excluding User Content) are owned by AllGoodsApp or its licensors. You may not use any trademark, service mark, logo, or other proprietary information of AllGoodsApp without our prior written consent.

        5.2. Feedback: If you choose to provide input or suggestions regarding the App ("Feedback"), you agree that AllGoodsApp may use that Feedback without any obligation to you.

        6. Termination

        We may terminate or suspend your access to the App immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms.

        7. Limitation of Liability

        To the fullest extent permitted by applicable law, in no event shall AllGoodsApp, its affiliates, directors, officers, employees, agents, or licensors be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation damages for lost profits, data, use, goodwill, or other intangibles, arising from or relating to your use of the App.

        8. Governing Law

        These Terms shall be governed by and construed in accordance with the laws of the State of [Your State], without regard to its conflict of law provisions.

        9. Changes to Terms

        AllGoodsApp reserves the right to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.

        10. Contact Us

        If you have any questions about these Terms, please contact us at support@allgoodsapp.com.

        By using AllGoodsApp, you agree to these Terms. If you do not agree to these Terms, please do not use the App.


        """
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
        termsTextView.delegate = self
        acceptButton.isEnabled = false
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
