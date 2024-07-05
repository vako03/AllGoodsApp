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

class TermsViewController: UIViewController {
    weak var delegate: TermsViewControllerDelegate?

    private let termsTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Terms and Conditions\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vel lorem nec ligula placerat elementum. Nullam vitae sapien ut purus elementum aliquet. Integer id massa sit amet lorem ultrices interdum. Suspendisse potenti. Nam et sagittis quam, non vehicula justo. Proin fermentum ligula a scelerisque lacinia. Cras posuere risus justo, nec scelerisque leo faucibus nec. Proin varius purus ac urna facilisis, nec pretium odio fermentum. Maecenas fringilla, justo vel porttitor ultrices, metus magna aliquet orci, in sagittis nisl metus a nisi. Nullam cursus, sem id ullamcorper efficitur, velit turpis hendrerit felis, in fermentum ligula erat eu leo. Nam cursus, est ut viverra lacinia, lectus turpis vehicula est, et convallis odio nulla eu velit. Proin hendrerit lacinia justo, in aliquam nulla dictum non. Vivamus dictum ex vel velit porttitor, sit amet sagittis eros tincidunt. Aenean sed diam at lacus malesuada interdum. In lobortis, est sed tincidunt tristique, lectus risus porta eros, vel fringilla nisi eros ut velit. Phasellus malesuada vehicula tortor. Aenean tincidunt velit vitae urna ultrices cursus.\n\nDonec scelerisque metus vel consectetur elementum. Integer ut dolor odio. Vivamus ac nisi magna. Nam congue, arcu vel convallis tincidunt, magna ligula tincidunt turpis, ut aliquet odio purus a magna. Curabitur id pharetra lorem. Integer malesuada nulla nec feugiat ultrices. Duis interdum gravida erat a laoreet. Integer bibendum lacus et nulla elementum, vitae malesuada lacus rutrum. Integer porttitor vehicula nunc nec convallis. Etiam ullamcorper erat at augue mollis consequat. Pellentesque eget convallis mauris, vitae viverra elit."
        textView.isEditable = false
                textView.translatesAutoresizingMaskIntoConstraints = false
                return textView
            }()

            private lazy var acceptButton: UIButton = {
                let button = UIButton(type: .system)
                button.setTitle("Accept", for: .normal)
                button.backgroundColor = .black
                button.tintColor = .white
                button.layer.cornerRadius = 15
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
                return button
            }()

            override func viewDidLoad() {
                super.viewDidLoad()
                view.backgroundColor = .white
                setupUI()
            }

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
                    acceptButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                    acceptButton.heightAnchor.constraint(equalToConstant: 50)
                ])
            }

            @objc private func acceptTapped() {
                delegate?.didAcceptTerms()
                dismiss(animated: true, completion: nil)
            }
        }
