//
//  SecondOnboardingPageViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit

class SecondOnboardingPageViewController: UIViewController {
    var titleText: String?
    var descriptionText: String?

    // MARK: - UI Elements
    private let titleLabel = CustomLabel(text: "", fontSize: 24, textColor: .black, alignment: .center)
    private let descriptionLabel = CustomLabel(text: "", fontSize: 16, textColor: .gray, alignment: .center)
    private let imageView3D = CustomImageView(image: UIImage(named: "SecondOnboard"))

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateImage3D()
    }

    // MARK: - Setup UI
    private func setupUI() {
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText

        let stackView = UIStackView(arrangedSubviews: [imageView3D, titleLabel, descriptionLabel])
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
            imageView3D.widthAnchor.constraint(equalToConstant: 250),
            imageView3D.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    // MARK: - Animations
    private func animateImage3D() {
        imageView3D.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.imageView3D.transform = .identity
        }, completion: { _ in
            self.spinImage3D()
        })
    }

    private func spinImage3D() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.imageView3D.transform = CGAffineTransform(rotationAngle: -.pi / 9) // Rotate 20 degrees to the left
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
                self.imageView3D.transform = CGAffineTransform(rotationAngle: .pi / 9) // Rotate 20 degrees to the right
            }, completion: nil)
        })
    }
}

