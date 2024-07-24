//
//  PrivacyTermsViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 24.07.24.
//

import UIKit

class PrivacyTermsViewController: UIViewController {
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = """
        Welcome to the PrivacyTermsViewController of our Mobile Shopping App, where we prioritize your privacy and security while enhancing your shopping experience. This dedicated section ensures that you, our valued user, are informed and empowered regarding how your data is collected, used, and protected within our app ecosystem.

        Understanding Your Privacy

        At the heart of our PrivacyTermsViewController lies a commitment to transparency. We believe in clarity regarding the information we collect from you, how it is processed, and the measures we take to safeguard it. By providing this information upfront, we aim to build trust and foster a secure environment for your online shopping activities.

        Data Collection and Usage

        When you interact with our app, certain data points may be collected to personalize your experience and improve our services. This includes:

        Personal Information: Such as your name, contact details, and billing information, which are essential for processing orders and delivering products to you.

        Device Information: Including your device type, operating system, and unique device identifiers, which help us optimize our app’s performance and troubleshoot any technical issues.

        Usage Data: Such as your browsing behavior, preferences, and interactions with the app, which enable us to tailor recommendations and enhance usability.

        How We Protect Your Information

        Securing your data is paramount to us. Our PrivacyTermsViewController outlines comprehensive measures we employ to protect your information from unauthorized access, alteration, disclosure, or destruction. These measures include:

        Encryption: Utilizing industry-standard encryption protocols to safeguard data transmission between your device and our servers.

        Access Controls: Restricting access to your personal information to authorized personnel only, who are bound by strict confidentiality agreements.

        Regular Audits: Conducting routine audits of our security practices and infrastructure to ensure compliance with the latest industry standards and regulations.

        Your Rights and Choices

        In accordance with global privacy laws, our PrivacyTermsViewController informs you of your rights regarding your personal data. These rights include:

        Access: The right to access the personal information we hold about you.

        Correction: The ability to correct any inaccuracies in your personal data.

        Deletion: The right to request the deletion of your data under certain circumstances.

        We empower you to manage your preferences through our app settings, enabling you to control how your information is used for marketing purposes or shared with third parties.

        Contact Us

        Should you have any questions, concerns, or requests regarding our PrivacyTermsViewController or how we handle your data, please do not hesitate to contact our dedicated support team. Your feedback is invaluable in helping us maintain the highest standards of privacy and security.

        Conclusion

        In conclusion, our PrivacyTermsViewController serves as a testament to our commitment to protecting your privacy and providing you with a secure and enjoyable shopping experience. By adhering to these principles and practices, we strive to earn your trust and confidence as your preferred mobile shopping app.

        Thank you for choosing our app. We look forward to serving you and ensuring that your privacy remains our top priority.
        """
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Privacy & Terms"
        setupViews()
    }

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
}
