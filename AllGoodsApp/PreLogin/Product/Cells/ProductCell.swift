//
//  ProductCell.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//

import UIKit
import SDWebImage

class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    weak var delegate: ProductSelectionDelegate?
    public var product: Product?
    private var viewModel: ProductViewModel?
    private var currentImageUrl: URL?
    
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
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
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
    
    private let heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage(systemName: "heart")
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
        button.tintColor = .black
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.title = "Add"
            configuration.image = UIImage(systemName: "cart")
            configuration.imagePadding = 5
            configuration.background.cornerRadius = 5
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            configuration.image = configuration.image?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            
            var titleAttr = AttributedString("Add")
            titleAttr.font = UIFont.systemFont(ofSize: 12)
            configuration.attributedTitle = titleAttr

            button.configuration = configuration
        } else {
            button.setTitle("Add", for: .normal)
            button.setImage(UIImage(systemName: "cart"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -10, bottom: 5, right: 10)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)  // Set desired font size here
        }
        return button
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        contentView.addSubview(priceLabel)
        contentView.addSubview(starIconImageView)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(heartButton)
        contentView.addSubview(addToCartButton)
        contentView.addSubview(separatorView)
        
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: heartButton.leadingAnchor, constant: -10),
            
            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            starIconImageView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            starIconImageView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            starIconImageView.widthAnchor.constraint(equalToConstant: 20),
            starIconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            ratingLabel.leadingAnchor.constraint(equalTo: starIconImageView.trailingAnchor, constant: 4),
            ratingLabel.centerYAnchor.constraint(equalTo: starIconImageView.centerYAnchor),
            
            heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            heartButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            heartButton.widthAnchor.constraint(equalToConstant: 45),
            heartButton.heightAnchor.constraint(equalToConstant: 25),
            
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            addToCartButton.heightAnchor.constraint(equalToConstant: 25),
            addToCartButton.widthAnchor.constraint(equalToConstant: 95),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Configuration
    func configure(with product: Product, viewModel: ProductViewModel) {
        self.product = product
        self.viewModel = viewModel
        
        let imageUrl = URL(string: product.thumbnail)
        if currentImageUrl != imageUrl {
            currentImageUrl = imageUrl
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        
        titleLabel.text = product.title
        priceLabel.text = "$\(String(format: "%.2f", product.price))"
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
        NotificationCenter.default.post(name: .favoritesUpdated, object: product.id)
    }
    
    @objc private func addToCartButtonTapped() {
        guard let product = product, let viewModel = viewModel else { return }
        viewModel.toggleCart(productId: product.id)
        isAddedToCart.toggle()
        updateAddToCartButtonAppearance()
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
            configuration?.baseForegroundColor = isFavorite ? .red : .black
            configuration?.background.backgroundColor = .clear
            heartButton.configuration = configuration
        } else {
            heartButton.setImage(icon, for: .normal)
            heartButton.tintColor = isFavorite ? .red : .black
            heartButton.backgroundColor = .clear
        }
    }
    
    private func updateAddToCartButtonAppearance() {
        let tintColor: UIColor = .black
        let title: String = isAddedToCart ? "Remove" : "Add"
        let icon = UIImage(systemName: "cart")?.withRenderingMode(.alwaysTemplate)
        
        if #available(iOS 15.0, *) {
            var configuration = addToCartButton.configuration
            configuration?.baseForegroundColor = tintColor
            configuration?.title = title
            configuration?.image = icon?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
            configuration?.background.backgroundColor = .clear
            
            var titleAttr = AttributedString(title)
            titleAttr.font = UIFont.systemFont(ofSize: 12)
            configuration?.attributedTitle = titleAttr
            
            addToCartButton.configuration = configuration
        } else {
            addToCartButton.setTitle(title, for: .normal)
            addToCartButton.setImage(icon, for: .normal)
            addToCartButton.tintColor = tintColor
            addToCartButton.backgroundColor = .clear
            addToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)  
        }
    }
}
