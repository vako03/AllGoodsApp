//
//  ProductDetailsViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//
import UIKit

class ProductDetailViewController: UIViewController {
    private let product: Product
    
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

        let brandLabel = UILabel()
        brandLabel.font = UIFont.systemFont(ofSize: 16)
        brandLabel.text = "Brand: \(product.brand ?? "N/A")"
        brandLabel.translatesAutoresizingMaskIntoConstraints = false

        let categoryLabel = UILabel()
        categoryLabel.font = UIFont.systemFont(ofSize: 16)
        categoryLabel.text = "Category: \(product.category)"
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false

        let stockLabel = UILabel()
        stockLabel.font = UIFont.systemFont(ofSize: 16)
        stockLabel.text = "Stock: \(product.stock)"
        stockLabel.translatesAutoresizingMaskIntoConstraints = false

        let availabilityLabel = UILabel()
        availabilityLabel.font = UIFont.systemFont(ofSize: 16)
        availabilityLabel.text = "Availability: \(product.availabilityStatus ?? "N/A")"
        availabilityLabel.translatesAutoresizingMaskIntoConstraints = false

        let ratingLabel = UILabel()
        ratingLabel.font = UIFont.systemFont(ofSize: 16)
        ratingLabel.text = "Rating: \(product.rating)"
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        let tagsLabel = UILabel()
        tagsLabel.font = UIFont.systemFont(ofSize: 16)
        tagsLabel.text = "Tags: \(product.tags?.joined(separator: ", ") ?? "N/A")"
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false

        let skuLabel = UILabel()
        skuLabel.font = UIFont.systemFont(ofSize: 16)
        skuLabel.text = "SKU: \(product.sku ?? "N/A")"
        skuLabel.translatesAutoresizingMaskIntoConstraints = false

        let weightLabel = UILabel()
        weightLabel.font = UIFont.systemFont(ofSize: 16)
        weightLabel.text = "Weight: \(product.weight ?? 0) kg"
        weightLabel.translatesAutoresizingMaskIntoConstraints = false

        let dimensionsLabel = UILabel()
        dimensionsLabel.font = UIFont.systemFont(ofSize: 16)
        if let dimensions = product.dimensions {
            dimensionsLabel.text = "Dimensions: \(dimensions.width) x \(dimensions.height) x \(dimensions.depth)"
        } else {
            dimensionsLabel.text = "Dimensions: N/A"
        }
        dimensionsLabel.translatesAutoresizingMaskIntoConstraints = false

        let warrantyLabel = UILabel()
        warrantyLabel.font = UIFont.systemFont(ofSize: 16)
        warrantyLabel.text = "Warranty: \(product.warrantyInformation ?? "N/A")"
        warrantyLabel.translatesAutoresizingMaskIntoConstraints = false

        let shippingLabel = UILabel()
        shippingLabel.font = UIFont.systemFont(ofSize: 16)
        shippingLabel.text = "Shipping: \(product.shippingInformation ?? "N/A")"
        shippingLabel.translatesAutoresizingMaskIntoConstraints = false

        let returnPolicyLabel = UILabel()
        returnPolicyLabel.font = UIFont.systemFont(ofSize: 16)
        returnPolicyLabel.text = "Return Policy: \(product.returnPolicy ?? "N/A")"
        returnPolicyLabel.translatesAutoresizingMaskIntoConstraints = false

        let minimumOrderQuantityLabel = UILabel()
        minimumOrderQuantityLabel.font = UIFont.systemFont(ofSize: 16)
        minimumOrderQuantityLabel.text = "Min. Order Quantity: \(product.minimumOrderQuantity ?? 1)"
        minimumOrderQuantityLabel.translatesAutoresizingMaskIntoConstraints = false

        let reviewsLabel = UILabel()
        reviewsLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        reviewsLabel.text = "Reviews"
        reviewsLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(brandLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(availabilityLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(tagsLabel)
        contentView.addSubview(skuLabel)
        contentView.addSubview(weightLabel)
        contentView.addSubview(dimensionsLabel)
        contentView.addSubview(warrantyLabel)
        contentView.addSubview(shippingLabel)
        contentView.addSubview(returnPolicyLabel)
        contentView.addSubview(minimumOrderQuantityLabel)
        contentView.addSubview(reviewsLabel)

        var previousLabel: UILabel? = nil
        for review in product.reviews ?? [] {
            let reviewLabel = UILabel()
            reviewLabel.font = UIFont.systemFont(ofSize: 14)
            reviewLabel.numberOfLines = 0
            reviewLabel.text = "\(review.reviewerName) (\(review.rating) stars): \(review.comment)"
            reviewLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(reviewLabel)
            
            if let previous = previousLabel {
                NSLayoutConstraint.activate([
                    reviewLabel.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 8),
                    reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
                ])
            } else {
                NSLayoutConstraint.activate([
                    reviewLabel.topAnchor.constraint(equalTo: reviewsLabel.bottomAnchor, constant: 8),
                    reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
                ])
            }
            previousLabel = reviewLabel
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            brandLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            categoryLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stockLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
            stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            availabilityLabel.topAnchor.constraint(equalTo: stockLabel.bottomAnchor, constant: 16),
            availabilityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            availabilityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            ratingLabel.topAnchor.constraint(equalTo: availabilityLabel.bottomAnchor, constant: 16),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            tagsLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16),
            tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            skuLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 16),
            skuLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            skuLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            weightLabel.topAnchor.constraint(equalTo: skuLabel.bottomAnchor, constant: 16),
            weightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            weightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            dimensionsLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 16),
            dimensionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dimensionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            warrantyLabel.topAnchor.constraint(equalTo: dimensionsLabel.bottomAnchor, constant: 16),
            warrantyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            warrantyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            shippingLabel.topAnchor.constraint(equalTo: warrantyLabel.bottomAnchor, constant: 16),
            shippingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shippingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            returnPolicyLabel.topAnchor.constraint(equalTo: shippingLabel.bottomAnchor, constant: 16),
            returnPolicyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            returnPolicyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            minimumOrderQuantityLabel.topAnchor.constraint(equalTo: returnPolicyLabel.bottomAnchor, constant: 16),
            minimumOrderQuantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            minimumOrderQuantityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            reviewsLabel.topAnchor.constraint(equalTo: minimumOrderQuantityLabel.bottomAnchor, constant: 16),
            reviewsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reviewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        if let lastReviewLabel = previousLabel {
            lastReviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        } else {
            reviewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        }
    }

    private func getPriceAttributedText(for product: Product) -> NSAttributedString {
        let originalPrice = "$\(product.price)"
        let discountedPrice = "$\(product.price - (product.price * product.discountPercentage / 100))"
        
        let originalPriceAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.systemRed,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let discountedPriceAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.systemGreen
        ]
        
        let originalPriceAttributedString = NSAttributedString(string: originalPrice, attributes: originalPriceAttributes)
        let discountedPriceAttributedString = NSAttributedString(string: " \(discountedPrice)", attributes: discountedPriceAttributes)
        
        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(originalPriceAttributedString)
        combinedAttributedString.append(discountedPriceAttributedString)
        
        return combinedAttributedString
    }
}

// Extension to load image from URL
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
