//
//  CategoryCell.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"

    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with category: String, imageUrl: URL?, viewModel: ProductViewModel) {
        titleLabel.text = category.capitalized
        if let imageUrl = imageUrl {
            imageView.load(url: imageUrl)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
}
