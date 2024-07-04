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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let imageView3D: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SecondOnboard")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var imageView3DLeadingConstraint: NSLayoutConstraint?
    private var imageView3DCenterXConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImage3D()
    }

    private func setupUI() {
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(imageView3D)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView3D.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            imageView3D.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            imageView3D.widthAnchor.constraint(equalToConstant: 250),
            imageView3D.heightAnchor.constraint(equalToConstant: 250)
        ])

        imageView3DLeadingConstraint = imageView3D.leadingAnchor.constraint(equalTo: view.trailingAnchor)
        imageView3DLeadingConstraint?.isActive = true
    }

    private func animateImage3D() {
        view.layoutIfNeeded() // Ensure all layout operations are completed

        imageView3DLeadingConstraint?.isActive = false
        imageView3DCenterXConstraint = imageView3D.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        imageView3DCenterXConstraint?.isActive = true

        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.spinImage3D()
        })
    }

    private func spinImage3D() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut, .autoreverse, .repeat], animations: {
            self.imageView3D.transform = CGAffineTransform(rotationAngle: -.pi / 4.5) // 40 degrees to the left
        })
    }
}
