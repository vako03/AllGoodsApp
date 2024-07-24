//
//  OrderCell.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 23.07.24.
//

import UIKit
import SDWebImage


class OrderCell: UITableViewCell {
    static let identifier = "OrderCell"
    
    // MARK: - Properties
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let customerInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(productImageView)
        contentView.addSubview(customerInfoLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            
            customerInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            customerInfoLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            customerInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            dateLabel.topAnchor.constraint(equalTo: customerInfoLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: customerInfoLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            amountLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            amountLabel.leadingAnchor.constraint(equalTo: customerInfoLabel.leadingAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            amountLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Configuration
    func configure(with order: Order) {
        if let url = URL(string: order.productThumbnail) {
            productImageView.sd_setImage(with: url, completed: nil)
        }
        customerInfoLabel.text = "Customer: \(order.customerEmail), \(order.customerPhoneNumber)"
        dateLabel.text = "Date: \(order.date)"
        amountLabel.text = "Amount: \(order.amount)"
    }
}
