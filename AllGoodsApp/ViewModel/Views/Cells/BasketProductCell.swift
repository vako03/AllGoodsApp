//
//  BasketProductCell.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 16.07.24.
//

import UIKit
import SDWebImage

protocol BasketProductCellDelegate: AnyObject {
    func didUpdateQuantity(for product: Product, quantity: Int)
    func didRemoveProduct(_ product: Product)
}

class BasketProductCell: UICollectionViewCell {
    static let identifier = "BasketProductCell"
    weak var delegate: BasketProductCellDelegate?
    private var cartProduct: CartProduct?
    private var viewModel: ProductViewModel?
    private var currentImageUrl: URL?

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
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let trashButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(minusButton)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(trashButton)

        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        trashButton.addTarget(self, action: #selector(removeProduct), for: .touchUpInside)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trashButton.leadingAnchor, constant: -10),

            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),

            minusButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            minusButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            minusButton.heightAnchor.constraint(equalToConstant: 30),

            quantityLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: 8),
            quantityLabel.centerYAnchor.constraint(equalTo: minusButton.centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),

            plusButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 8),
            plusButton.centerYAnchor.constraint(equalTo: minusButton.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30),

            trashButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            trashButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            trashButton.widthAnchor.constraint(equalToConstant: 30),
            trashButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with cartProduct: CartProduct, viewModel: ProductViewModel) {
        self.cartProduct = cartProduct
        self.viewModel = viewModel

        let imageUrl = URL(string: cartProduct.product.thumbnail)
        if currentImageUrl != imageUrl {
            currentImageUrl = imageUrl
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        
        titleLabel.text = cartProduct.product.title
        priceLabel.text = "$\(String(format: "%.2f", cartProduct.product.price))"
        quantityLabel.text = "\(cartProduct.quantity)" // Use actual quantity
    }

    @objc private func decreaseQuantity() {
        if let cartProduct = cartProduct {
            var quantity = cartProduct.quantity
            if quantity > 1 {
                quantity -= 1
                quantityLabel.text = "\(quantity)"
                delegate?.didUpdateQuantity(for: cartProduct.product, quantity: quantity)
            }
        }
    }

    @objc private func increaseQuantity() {
        if let cartProduct = cartProduct {
            var quantity = cartProduct.quantity
            quantity += 1
            quantityLabel.text = "\(quantity)"
            delegate?.didUpdateQuantity(for: cartProduct.product, quantity: quantity)
        }
    }

    @objc private func removeProduct() {
        if let cartProduct = cartProduct {
            delegate?.didRemoveProduct(cartProduct.product)
        }
    }
}
