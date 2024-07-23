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
    private var seeMoreButton: UIButton!
    private var additionalDetailsLabel: UILabel!
    private var isShowingMoreInfo = false
    private let viewModel = ProductViewModel()

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = product.title
        view.backgroundColor = .white
        setupUI()
        updateFavoriteStatus()
        updateCartStatus()
    }

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

        let detailsLabel = UILabel()
        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.numberOfLines = 0
        detailsLabel.text = getDetailsText(for: product)
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false

        additionalDetailsLabel = UILabel()
        additionalDetailsLabel.font = UIFont.systemFont(ofSize: 14)
        additionalDetailsLabel.numberOfLines = 1
        additionalDetailsLabel.text = getAdditionalDetailsText(for: product)
        additionalDetailsLabel.textColor = .lightGray
        additionalDetailsLabel.translatesAutoresizingMaskIntoConstraints = false

        seeMoreButton = UIButton(type: .system)
        seeMoreButton.setTitle("See More Info", for: .normal)
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        seeMoreButton.addTarget(self, action: #selector(toggleMoreInfo), for: .touchUpInside)

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

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(additionalDetailsLabel)
        contentView.addSubview(seeMoreButton)
        contentView.addSubview(heartButton)
        contentView.addSubview(addToCartButton)
        contentView.addSubview(proceedToCheckoutButton)

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

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            heartButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 20),
            heartButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),

            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),

            addToCartButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 32),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            addToCartButton.widthAnchor.constraint(equalToConstant: 160),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),

            proceedToCheckoutButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 32),
            proceedToCheckoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            proceedToCheckoutButton.widthAnchor.constraint(equalToConstant: 160),
            proceedToCheckoutButton.heightAnchor.constraint(equalToConstant: 50),

            addToCartButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
            proceedToCheckoutButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),

            detailsLabel.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: 32),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),

            additionalDetailsLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 8),
            additionalDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            additionalDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),

            seeMoreButton.topAnchor.constraint(equalTo: additionalDetailsLabel.bottomAnchor, constant: 8),
            seeMoreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            seeMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    @objc private func toggleMoreInfo() {
        isShowingMoreInfo.toggle()
        additionalDetailsLabel.numberOfLines = isShowingMoreInfo ? 0 : 1
        additionalDetailsLabel.textColor = isShowingMoreInfo ? .black : .lightGray
        let buttonTitle = isShowingMoreInfo ? "See Less Info" : "See More Info"
        seeMoreButton.setTitle(buttonTitle, for: .normal)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
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
        
        let contactInformationView = ContactInformationView(nickname: nickname, email: email)
        let hostingController = UIHostingController(rootView: contactInformationView)
        navigationController?.pushViewController(hostingController, animated: true)
    }

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

    private func getDetailsText(for product: Product) -> String {
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
        if let warrantyInformation = product.warrantyInformation {
            details += "Warranty: \(warrantyInformation)\n"
        }
        if let shippingInformation = product.shippingInformation {
            details += "Shipping: \(shippingInformation)\n"
        }
        if let availabilityStatus = product.availabilityStatus {
            details += "Availability: \(availabilityStatus)\n"
        }
        if let returnPolicy = product.returnPolicy {
            details += "Return Policy: \(returnPolicy)\n"
        }
        if let minimumOrderQuantity = product.minimumOrderQuantity {
            details += "Minimum Order Quantity: \(minimumOrderQuantity)\n"
        }
        return details
    }

    private func getAdditionalDetailsText(for product: Product) -> String {
        var details = ""

        if let meta = product.meta {
            details += "Created At: \(meta.createdAt)\n"
            details += "Updated At: \(meta.updatedAt)\n"
            details += "Barcode: \(meta.barcode)\n"
            details += "QR Code: \(meta.qrCode)\n"
        }
        return details
    }
}

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
