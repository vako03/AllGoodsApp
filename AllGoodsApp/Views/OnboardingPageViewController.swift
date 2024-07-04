//
//  OnboardingPageViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
//import UIKit
//
//class OnboardingPageViewController: UIViewController {
//    var titleText: String?
//    var descriptionText: String?
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//        label.textColor = .black
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        label.textColor = .gray
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private let parcelImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "Parcel")
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        animateParcelImage()
//    }
//
//    private func setupUI() {
//        titleLabel.text = titleText
//        descriptionLabel.text = descriptionText
//
//        view.addSubview(titleLabel)
//        view.addSubview(descriptionLabel)
//        view.addSubview(parcelImageView)
//
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        parcelImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//
//            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//
//            parcelImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            parcelImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -280), // Start position above the top of the screen
//            parcelImageView.widthAnchor.constraint(equalToConstant: 250), // Double the size
//            parcelImageView.heightAnchor.constraint(equalToConstant: 250) // Double the size
//        ])
//    }
//
//    private func animateParcelImage() {
//        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut], animations: {
//            self.parcelImageView.transform = CGAffineTransform(translationX: 0, y: self.view.center.y + 50)
//        }) { _ in
//            self.moveParcelImageSideways()
//        }
//    }
//
//    private func moveParcelImageSideways() {
//        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
//            self.parcelImageView.transform = CGAffineTransform(translationX: 20, y: self.view.center.y + 50)
//        }) { _ in
//            UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
//                self.parcelImageView.transform = CGAffineTransform(translationX: -20, y: self.view.center.y + 50)
//            }, completion: nil)
//        }
//    }
//}
