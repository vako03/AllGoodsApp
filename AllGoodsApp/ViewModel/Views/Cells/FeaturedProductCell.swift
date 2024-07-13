//
//  FeaturedProductCell.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import UIKit

class FeaturedProductCell: UICollectionViewCell {
    static let identifier = "FeaturedProductCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let discountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.text = "Best Offer"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4 // Increased spacing for larger icons
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        let smallIcon = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { _ in
            icon?.draw(in: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        }
        button.setImage(smallIcon, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        let icon = UIImage(named: "shopping-cart")?.withRenderingMode(.alwaysTemplate)
        let bigIcon = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
            icon?.draw(in: CGRect(origin: .zero, size: CGSize(width: 25, height: 25)))
        }
        button.setImage(bigIcon, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        // Use UIButtonConfiguration for iOS 15 and later
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = bigIcon
            config.title = "Add"
            config.imagePadding = 5
            button.configuration = config
        } else {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var isFavorite: Bool = false {
        didSet {
            updateHeartButtonAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(discountLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starStackView)
        contentView.addSubview(heartButton)
        contentView.addSubview(addToCartButton)

        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            discountLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            discountLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),

            starStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            starStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            heartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            heartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            heartButton.widthAnchor.constraint(equalToConstant: 30),
            heartButton.heightAnchor.constraint(equalToConstant: 30),

            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            addToCartButton.leadingAnchor.constraint(equalTo: heartButton.trailingAnchor, constant: 5),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addToCartButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with product: Product) {
        if let url = URL(string: product.thumbnail) {
            imageView.load(url: url)
        }
        discountLabel.text = "\(product.discountPercentage)%"
        titleLabel.text = product.title

        starStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let fullStars = Int(product.rating)
        let halfStar = product.rating - Double(fullStars) >= 0.5

        for _ in 0..<fullStars {
            let starIcon = UIImageView(image: UIImage(named: "star"))
            starIcon.tintColor = .yellow
            starIcon.translatesAutoresizingMaskIntoConstraints = false
            starIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
            starIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
            starStackView.addArrangedSubview(starIcon)
        }

        if halfStar {
            let halfStarIcon = UIImageView(image: UIImage(named: "half_star"))
            halfStarIcon.tintColor = .yellow
            halfStarIcon.translatesAutoresizingMaskIntoConstraints = false
            halfStarIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
            halfStarIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
            starStackView.addArrangedSubview(halfStarIcon)
        }
    }
    
    @objc private func heartButtonTapped() {
        isFavorite.toggle()
        animateHeartButton()
    }

    private func updateHeartButtonAppearance() {
        let iconName = isFavorite ? "heart_fill" : "heart"
        let icon = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        let smallIcon = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { _ in
            icon?.draw(in: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        }
        heartButton.setImage(smallIcon, for: .normal)
        heartButton.tintColor = isFavorite ? .red : .black
    }

    private func animateHeartButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.heartButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.heartButton.transform = CGAffineTransform.identity
            }
        }
    }
}
