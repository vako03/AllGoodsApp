//
//  ProductDetailsViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//

import UIKit

final class ProductDetailsViewController: UIViewController {
    private let product: Product

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let titleLabel = CustomLabel(text: "", fontSize: 24, textColor: .black, alignment: .center)
    private let descriptionLabel = CustomLabel(text: "", fontSize: 16, textColor: .darkGray, alignment: .left)
    private let priceLabel = CustomLabel(text: "", fontSize: 20, textColor: .systemBlue, alignment: .left)
    private let discountLabel = CustomLabel(text: "", fontSize: 18, textColor: .systemRed, alignment: .left)
    private let ratingLabel = CustomLabel(text: "", fontSize: 18, textColor: .systemGreen, alignment: .left)
    private let stockLabel = CustomLabel(text: "", fontSize: 18, textColor: .systemOrange, alignment: .left)
    private let brandLabel = CustomLabel(text: "", fontSize: 18, textColor: .systemGray, alignment: .left)
    private let categoryLabel = CustomLabel(text: "", fontSize: 18, textColor: .systemPurple, alignment: .left)

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        displayProductDetails()
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel, priceLabel, discountLabel, ratingLabel, stockLabel, brandLabel, categoryLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            imageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func displayProductDetails() {
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        priceLabel.text = "Price: $\(product.price)"
        discountLabel.text = "Discount: \(product.discountPercentage)%"
        ratingLabel.text = "Rating: \(product.rating)"
        stockLabel.text = "Stock: \(product.stock)"
        brandLabel.text = "Brand: \(product.brand)"
        categoryLabel.text = "Category: \(product.category)"
        if let url = URL(string: product.thumbnail) {
            NetworkManager.shared.fetchImage(from: url) { [weak self] data in
                DispatchQueue.main.async {
                    if let data = data {
                        self?.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
