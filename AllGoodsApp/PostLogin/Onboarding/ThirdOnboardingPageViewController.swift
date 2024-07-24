//
//  ThirdOnboardingPageViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//

import UIKit

class ThirdOnboardingPageViewController: UIViewController {
    var titleText: String?
    var descriptionText: String?
    var coordinator: AppCoordinator?

    // MARK: - UI Elements
    private let titleLabel = CustomLabel(text: "", fontSize: 24, textColor: .black, alignment: .center)
    private let descriptionLabel = CustomLabel(text: "", fontSize: 16, textColor: .gray, alignment: .center)
    private let imageViewShopping = CustomImageView(image: UIImage(named: "ThirdOnboard"))

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateShoppingImage()
    }

    // MARK: - Setup UI
    private func setupUI() {
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText

        let stackView = UIStackView(arrangedSubviews: [imageViewShopping, titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            imageViewShopping.widthAnchor.constraint(equalToConstant: 250),
            imageViewShopping.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    // MARK: - Animations
    private func animateShoppingImage() {
        imageViewShopping.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height)
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.imageViewShopping.transform = .identity
        }, completion: { _ in
            self.shakeShoppingImage()
        })
    }

    private func shakeShoppingImage() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.imageViewShopping.transform = CGAffineTransform(translationX: 10, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
                self.imageViewShopping.transform = CGAffineTransform(translationX: -10, y: 0)
            }, completion: nil)
        })
    }
}
