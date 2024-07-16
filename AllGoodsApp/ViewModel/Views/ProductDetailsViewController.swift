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
            tagsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
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
}

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.image = image
                }
            } catch {
                // Handle error
                DispatchQueue.main.async {
                    self?.image = UIImage(named: "placeholder") // Default placeholder image
                }
                print("Error loading image: \(error)")
            }
        }
    }
}
