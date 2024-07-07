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

    private let titleLabel = CustomLabel(text: "", fontSize: 24, textColor: .black, alignment: .center)
    private let descriptionLabel = CustomLabel(text: "", fontSize: 16, textColor: .gray, alignment: .center)
    private let imageViewShopping: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ThirdOnboard")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var imageViewShoppingLeadingConstraint: NSLayoutConstraint?
    private var imageViewShoppingCenterXConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShoppingImage()
    }

    private func setupUI() {
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(imageViewShopping)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        imageViewShopping.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            imageViewShopping.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            imageViewShopping.widthAnchor.constraint(equalToConstant: 250),
            imageViewShopping.heightAnchor.constraint(equalToConstant: 250)
        ])

        imageViewShoppingLeadingConstraint = imageViewShopping.leadingAnchor.constraint(equalTo: view.trailingAnchor)
        imageViewShoppingLeadingConstraint?.isActive = true
    }

    private func animateShoppingImage() {
        view.layoutIfNeeded() // Ensure all layout operations are completed

        imageViewShoppingLeadingConstraint?.isActive = false
        imageViewShoppingCenterXConstraint = imageViewShopping.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        imageViewShoppingCenterXConstraint?.isActive = true

        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.startSlowMovementAnimation()
        })
    }

    private func startSlowMovementAnimation() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.imageViewShopping.transform = CGAffineTransform(translationX: 20, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 2.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
                self.imageViewShopping.transform = CGAffineTransform(translationX: -20, y: 0)
            }, completion: nil)
        })
    }
}
