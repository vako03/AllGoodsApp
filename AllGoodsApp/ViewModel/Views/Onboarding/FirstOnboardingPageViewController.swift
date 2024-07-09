//
//  FirstOnboardingPageViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//

import UIKit

class FirstOnboardingPageViewController: UIViewController {
    var titleText: String?
    var descriptionText: String?

    private let titleLabel = CustomLabel(text: "", fontSize: 24, textColor: .black, alignment: .center)
    private let descriptionLabel = CustomLabel(text: "", fontSize: 16, textColor: .gray, alignment: .center)
    private let parcelImageView = CustomImageView(image: UIImage(named: "FirstOnboard"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        animateParcelImage()
    }

    private func setupUI() {
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText

        let stackView = UIStackView(arrangedSubviews: [parcelImageView, titleLabel, descriptionLabel])
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
            parcelImageView.widthAnchor.constraint(equalToConstant: 250),
            parcelImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func animateParcelImage() {
        parcelImageView.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height)
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.parcelImageView.transform = .identity
        }, completion: { _ in
            self.moveParcelImageSideways()
        })
    }

    private func moveParcelImageSideways() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.parcelImageView.transform = CGAffineTransform(translationX: 20, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
                self.parcelImageView.transform = CGAffineTransform(translationX: -20, y: 0)
            }, completion: nil)
        })
    }
}
