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
    
    private let discountIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let discountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 2
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
    
    private var isFavorite: Bool = false {
        didSet {
            updateHeartButtonAppearance()
        }
    }
    
    private var isAddedToCart: Bool = false {
        didSet {
            updateAddToCartButtonAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(discountIconImageView)
        contentView.addSubview(discountLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(newPriceLabel)
        contentView.addSubview(oldPriceLabel)
        contentView.addSubview(heartButton)
        contentView.addSubview(addToCartButton)
        
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            discountIconImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            discountIconImageView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            discountIconImageView.widthAnchor.constraint(equalToConstant: 20),
            discountIconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            discountLabel.centerYAnchor.constraint(equalTo: discountIconImageView.centerYAnchor),
            discountLabel.leadingAnchor.constraint(equalTo: discountIconImageView.trailingAnchor, constant: 4),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            newPriceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            newPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            oldPriceLabel.leadingAnchor.constraint(equalTo: newPriceLabel.trailingAnchor, constant: 8),
            oldPriceLabel.centerYAnchor.constraint(equalTo: newPriceLabel.centerYAnchor),
            
            heartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            heartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            heartButton.widthAnchor.constraint(equalToConstant: 45),
            heartButton.heightAnchor.constraint(equalToConstant: 25),
            
            addToCartButton.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor),
            addToCartButton.leadingAnchor.constraint(equalTo: heartButton.trailingAnchor, constant: 5),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            addToCartButton.heightAnchor.constraint(equalToConstant: 25),
            addToCartButton.widthAnchor.constraint(equalToConstant: 95) // Adjust width as needed
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: Product) {
        if let url = URL(string: product.thumbnail) {
            imageView.load(url: url)
        }
        
        // Set random discount icon
        let discountIcons = ["discount1", "discount2", "discount3", "discount4"]
        let randomIcon = discountIcons.randomElement() ?? "discount1"
        discountIconImageView.image = UIImage(named: randomIcon)
        
        // Set discount label with integer part only
        let discountInt = Int(product.discountPercentage)
        discountLabel.text = "\(discountInt)%"
        
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
    }
    
    @objc private func heartButtonTapped() {
        isFavorite.toggle()
        animateHeartButton()
    }
    
    @objc private func addToCartButtonTapped() {
        isAddedToCart.toggle()
        animateAddToCartButton()
    }
    
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

