//
//  AllCategoryCell.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 12.07.24.
//

import UIKit

class AllCategoryCell: UICollectionViewCell {
    static let identifier = "AllCategoryCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "All Categories"
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "list.bullet") // Using SF Symbols
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .gray
        contentView.layer.cornerRadius = 8
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            iconImageView.widthAnchor.constraint(equalToConstant: 24), // Adjust size as needed
            iconImageView.heightAnchor.constraint(equalToConstant: 24) // Adjust size as needed
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
