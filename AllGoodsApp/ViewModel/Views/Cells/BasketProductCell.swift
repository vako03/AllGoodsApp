//
//  BasketProductCell.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 16.07.24.
//

import UIKit

protocol BasketProductCellDelegate: AnyObject {
    func didUpdateQuantity(for product: Product, quantity: Int)
    func didRemoveProduct(_ product: Product)
}

class BasketProductCell: UICollectionViewCell {
    static let identifier = "BasketProductCell"
    weak var delegate: BasketProductCellDelegate?
    private var product: Product?
    private var viewModel: ProductViewModel?
    private var quantity: Int = 1

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

    func configure(with product: Product, viewModel: ProductViewModel) {
        self.product = product
        self.viewModel = viewModel
        if let url = URL(string: product.thumbnail) {
            imageView.load(url: url)
        }
        titleLabel.text = product.title
        priceLabel.text = "$\(String(format: "%.2f", product.price))"
        quantityLabel.text = "\(quantity)"
    }

    @objc private func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
            quantityLabel.text = "\(quantity)"
            if let product = product {
                delegate?.didUpdateQuantity(for: product, quantity: quantity)
            }
        }
    }

    @objc private func increaseQuantity() {
        quantity += 1
        quantityLabel.text = "\(quantity)"
        if let product = product {
            delegate?.didUpdateQuantity(for: product, quantity: quantity)
        }
    }

    @objc private func removeProduct() {
        if let product = product {
            delegate?.didRemoveProduct(product)
        }
    }
}

