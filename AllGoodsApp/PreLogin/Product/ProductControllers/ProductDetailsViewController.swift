//
//  ProductDetailsViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//

import UIKit
import SwiftUI
import FirebaseAuth

class ProductDetailViewController: UIViewController {
    var coordinator: AppCoordinator?
    private let product: Product
    private var heartButton: UIButton!
    private var addToCartButton: UIButton!
    private var proceedToCheckoutButton: UIButton!
    private var toggleDetailsButton: UIButton!
    private var basicDetailsLabel: UILabel!
    private var additionalDetailsLabel: UILabel!
    private var additionalDetailsContainer: UIView!
    private let viewModel = ProductViewModel()
    private var showDetails: Bool = false

    // MARK: - Initialization
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = product.title
        view.backgroundColor = .white
        setupUI()
        updateFavoriteStatus()
        updateCartStatus()
    }

    // MARK: - Setup UI
    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let imageUrl = URL(string: product.thumbnail) {
            imageView.load(url: imageUrl)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }

        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.text = product.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = product.description
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        priceLabel.textColor = .systemGreen
        priceLabel.attributedText = getPriceAttributedText(for: product)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        basicDetailsLabel = UILabel()
        basicDetailsLabel.font = UIFont.systemFont(ofSize: 14)
        basicDetailsLabel.numberOfLines = 0
        basicDetailsLabel.text = getBasicDetailsText(for: product)
        basicDetailsLabel.translatesAutoresizingMaskIntoConstraints = false

        additionalDetailsContainer = UIView()
        additionalDetailsContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(additionalDetailsContainer)

        additionalDetailsLabel = UILabel()
        additionalDetailsLabel.font = UIFont.systemFont(ofSize: 14)
        additionalDetailsLabel.numberOfLines = 0
        additionalDetailsLabel.attributedText = getAdditionalDetailsAttributedText(for: product)
        additionalDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalDetailsLabel.isHidden = !showDetails
        additionalDetailsContainer.addSubview(additionalDetailsLabel)

        heartButton = UIButton(type: .system)
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.tintColor = .red
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        heartButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)

        addToCartButton = UIButton(type: .system)
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = .systemBlue
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)

        proceedToCheckoutButton = UIButton(type: .system)
        proceedToCheckoutButton.setTitle("Proceed to Checkout", for: .normal)
        proceedToCheckoutButton.setTitleColor(.white, for: .normal)
        proceedToCheckoutButton.backgroundColor = .systemGreen
        proceedToCheckoutButton.layer.cornerRadius = 10
        proceedToCheckoutButton.translatesAutoresizingMaskIntoConstraints = false
        proceedToCheckoutButton.addTarget(self, action: #selector(proceedToCheckout), for: .touchUpInside)

        toggleDetailsButton = UIButton(type: .system)
        toggleDetailsButton.setTitle("Show More Details", for: .normal)
        toggleDetailsButton.setTitleColor(.systemBlue, for: .normal)
        toggleDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        toggleDetailsButton.addTarget(self, action: #selector(toggleDetails), for: .touchUpInside)

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(heartButton)
        contentView.addSubview(addToCartButton)
        contentView.addSubview(proceedToCheckoutButton)
        contentView.addSubview(toggleDetailsButton)
        contentView.addSubview(basicDetailsLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            heartButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 20),
            heartButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            addToCartButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addToCartButton.widthAnchor.constraint(equalToConstant: 160),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),

            proceedToCheckoutButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            proceedToCheckoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            proceedToCheckoutButton.widthAnchor.constraint(equalToConstant: 160),
            proceedToCheckoutButton.heightAnchor.constraint(equalToConstant: 50),

            basicDetailsLabel.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: 16),
            basicDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            basicDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            additionalDetailsContainer.topAnchor.constraint(equalTo: basicDetailsLabel.bottomAnchor, constant: 16),
            additionalDetailsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            additionalDetailsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            additionalDetailsLabel.topAnchor.constraint(equalTo: additionalDetailsContainer.topAnchor),
            additionalDetailsLabel.leadingAnchor.constraint(equalTo: additionalDetailsContainer.leadingAnchor),
            additionalDetailsLabel.trailingAnchor.constraint(equalTo: additionalDetailsContainer.trailingAnchor),
            additionalDetailsLabel.bottomAnchor.constraint(equalTo: additionalDetailsContainer.bottomAnchor),

            toggleDetailsButton.topAnchor.constraint(equalTo: additionalDetailsContainer.bottomAnchor, constant: 16),
            toggleDetailsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            toggleDetailsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleDetailsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Action Methods
    @objc private func toggleDetails() {
        showDetails.toggle()
        additionalDetailsLabel.isHidden = !showDetails
        let buttonTitle = showDetails ? "Hide Details" : "Show More Details"
        toggleDetailsButton.setTitle(buttonTitle, for: .normal)
        additionalDetailsContainer.layoutIfNeeded() 
    }

    @objc private func addToFavorites() {
        SharedStorage.shared.toggleFavorite(productId: product.id)
        updateFavoriteStatus()
    }

    @objc private func addToCart() {
        SharedStorage.shared.toggleCart(productId: product.id)
        updateCartStatus()
    }

    @objc private func proceedToCheckout() {
        guard let currentUser = Auth.auth().currentUser, currentUser.displayName != "Guest" else {
            showLoginAlert()
            return
        }
        let nickname = currentUser.displayName ?? "Guest"
        let email = currentUser.email ?? ""
        
        let contactInformationView = ContactInformationView(nickname: nickname, email: email, cartProducts: [CartProduct(product: product, quantity: 1)])
        let hostingController = UIHostingController(rootView: contactInformationView)
        navigationController?.pushViewController(hostingController, animated: true)
    }

    // MARK: - Helper Methods
    private func showLoginAlert() {
        let alert = UIAlertController(title: "Login Required", message: "Please log in to continue.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { [weak self] _ in
            self?.coordinator?.showLogin()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func updateFavoriteStatus() {
        let isFavorite = SharedStorage.shared.isFavorite(productId: product.id)
        let heartImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        heartButton.setImage(heartImage, for: .normal)
    }

    private func updateCartStatus() {
        let isInCart = SharedStorage.shared.isInCart(productId: product.id)
        let buttonTitle = isInCart ? "Remove from Cart" : "Add to Cart"
        addToCartButton.setTitle(buttonTitle, for: .normal)
    }

    private func getPriceAttributedText(for product: Product) -> NSAttributedString {
        let originalPrice = "$\(String(format: "%.2f", product.price))"
        let discountedPrice = "$\(String(format: "%.2f", product.price - (product.price * product.discountPercentage / 100)))"
        
        let attributedText = NSMutableAttributedString(string: discountedPrice, attributes: [.foregroundColor: UIColor.systemGreen, .font: UIFont.systemFont(ofSize: 18, weight: .medium)])
        attributedText.append(NSAttributedString(string: " "))
        
        let originalPriceText = NSAttributedString(string: originalPrice, attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.gray,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ])
        attributedText.append(originalPriceText)
        
        return attributedText
    }

    private func getBasicDetailsText(for product: Product) -> String {
        var details = ""

        if let brand = product.brand {
            details += "Brand: \(brand)\n"
        }
        details += "Category: \(product.category)\n"
        details += "Stock: \(product.stock)\n"
        if let sku = product.sku {
            details += "SKU: \(sku)\n"
        }
        if let weight = product.weight {
            details += "Weight: \(weight) kg\n"
        }
        if let dimensions = product.dimensions {
            details += "Dimensions: \(dimensions.width) x \(dimensions.height) x \(dimensions.depth) cm\n"
        }
        if let availabilityStatus = product.availabilityStatus {
            details += "Availability: \(availabilityStatus)\n"
        }
        return details
    }

    private func getAdditionalDetailsAttributedText(for product: Product) -> NSAttributedString {
        var details = ""

        if let warrantyInformation = product.warrantyInformation {
            details += "Warranty: \(warrantyInformation)\n"
        }
        if let shippingInformation = product.shippingInformation {
            details += "Shipping: \(shippingInformation)\n"
        }
        if let returnPolicy = product.returnPolicy {
            details += "Return Policy: \(returnPolicy)\n"
        }
        if let minimumOrderQuantity = product.minimumOrderQuantity {
            details += "Minimum Order Quantity: \(minimumOrderQuantity)\n"
        }
        if let meta = product.meta {
            details += "Created At: \(meta.createdAt)\n"
            details += "Updated At: \(meta.updatedAt)\n"
            details += "Barcode: \(meta.barcode)\n"
            details += "QR Code: \(meta.qrCode)\n"
        }

        let attributedText = NSMutableAttributedString(string: details)

        if let range = details.range(of: details.components(separatedBy: "\n").first ?? "") {
            attributedText.addAttributes([.foregroundColor: UIColor.lightGray], range: NSRange(range, in: details))
        }

        return attributedText
    }
}

// MARK: - UIImageView Extension
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
