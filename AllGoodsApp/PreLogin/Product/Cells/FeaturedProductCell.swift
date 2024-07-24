//
//  FeaturedProductCell.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import UIKit

class FeaturedProductCell: UICollectionViewCell {
    static let identifier = "FeaturedProductCell"
    weak var delegate: ProductSelectionDelegate?
    public var product: Product?
    private var viewModel: ProductViewModel?

    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let oldPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        label.attributedText = NSAttributedString(string: "$0.00", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage(systemName: "heart")
            configuration.baseBackgroundColor = .link
            configuration.imagePadding = 10
            configuration.background.cornerRadius = 5
            configuration.image = configuration.image?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            button.configuration = configuration
        } else {
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        return button
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.title = "Add"
            configuration.image = UIImage(systemName: "cart")
            configuration.baseBackgroundColor = .darkGray
            configuration.imagePadding = 5
            configuration.background.cornerRadius = 5
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            configuration.image = configuration.image?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            button.configuration = configuration
        } else {
            button.setTitle("Add", for: .normal)
            button.setImage(UIImage(systemName: "cart"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -10, bottom: 5, right: 10)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        }
        return button
    }()
    
    public var isFavorite: Bool = false {
        didSet {
            updateHeartButtonAppearance()
        }
    }
    
    public var isAddedToCart: Bool = false {
        didSet {
            updateAddToCartButtonAppearance()
        }
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(newPriceLabel)
        contentView.addSubview(oldPriceLabel)
        contentView.addSubview(starIconImageView)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(heartButton)
        contentView.addSubview(addToCartButton)
        
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            newPriceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            newPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            oldPriceLabel.leadingAnchor.constraint(equalTo: newPriceLabel.trailingAnchor, constant: 8),
            oldPriceLabel.centerYAnchor.constraint(equalTo: newPriceLabel.centerYAnchor),
            
            starIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            starIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            starIconImageView.widthAnchor.constraint(equalToConstant: 20),
            starIconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            ratingLabel.centerYAnchor.constraint(equalTo: starIconImageView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: starIconImageView.trailingAnchor, constant: 4),
            
            heartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            heartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            heartButton.widthAnchor.constraint(equalToConstant: 45),
            heartButton.heightAnchor.constraint(equalToConstant: 25),
            
            addToCartButton.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor),
            addToCartButton.leadingAnchor.constraint(equalTo: heartButton.trailingAnchor, constant: 5),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            addToCartButton.heightAnchor.constraint(equalToConstant: 25),
            addToCartButton.widthAnchor.constraint(equalToConstant: 95)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with product: Product, viewModel: ProductViewModel) {
        self.product = product
        self.viewModel = viewModel
        if let url = URL(string: product.thumbnail) {
            imageView.load(url: url)
        }
        titleLabel.text = product.title
        
        let newPrice = product.price - (product.price * product.discountPercentage / 100)
        newPriceLabel.text = "$\(String(format: "%.2f", newPrice))"
        
        let attributedOldPrice = NSAttributedString(
            string: "$\(String(format: "%.2f", product.price))",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.gray,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        oldPriceLabel.attributedText = attributedOldPrice
        
        ratingLabel.text = "\(product.rating)"
        
        isFavorite = viewModel.isFavorite(productId: product.id)
        isAddedToCart = viewModel.isInCart(productId: product.id)
        updateHeartButtonAppearance()
        updateAddToCartButtonAppearance()
    }

    // MARK: - Actions
    @objc private func heartButtonTapped() {
        guard let product = product, let viewModel = viewModel else { return }
        viewModel.toggleFavorite(productId: product.id)
        isFavorite.toggle()
        updateHeartButtonAppearance()
        animateHeartButton()
        NotificationCenter.default.post(name: .favoritesUpdated, object: product.id)
    }
    
    @objc private func addToCartButtonTapped() {
        guard let product = product, let viewModel = viewModel else { return }
        viewModel.toggleCart(productId: product.id)
        isAddedToCart.toggle()
        updateAddToCartButtonAppearance()
        animateAddToCartButton()
        NotificationCenter.default.post(name: .cartUpdated, object: product.id)
    }
    
    @objc private func cellTapped() {
        if let product = product {
            delegate?.didSelectProduct(product)
        }
    }

    // MARK: - UI Updates
    private func updateHeartButtonAppearance() {
        let iconName = isFavorite ? "heart.fill" : "heart"
        let icon = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate)
        if #available(iOS 15.0, *) {
            var configuration = heartButton.configuration
            configuration?.image = icon?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            configuration?.baseForegroundColor = isFavorite ? .red : .white
            heartButton.configuration = configuration
        } else {
            heartButton.setImage(icon, for: .normal)
            heartButton.tintColor = isFavorite ? .red : .white
        }
    }
    
    private func updateAddToCartButtonAppearance() {
        let tintColor: UIColor = isAddedToCart ? .black : .white
        if #available(iOS 15.0, *) {
            var configuration = addToCartButton.configuration
            configuration?.baseForegroundColor = tintColor
            addToCartButton.configuration = configuration
        } else {
            addToCartButton.tintColor = tintColor
        }
    }

    // MARK: - Animations
    private func animateHeartButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.heartButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.heartButton.transform = CGAffineTransform.identity
            }
        }
    }
    
    private func animateAddToCartButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.addToCartButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            let tintColor: UIColor = self.isAddedToCart ? .black : .white
            self.addToCartButton.tintColor = tintColor
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.addToCartButton.transform = CGAffineTransform.identity
            }
        }
    }
}
