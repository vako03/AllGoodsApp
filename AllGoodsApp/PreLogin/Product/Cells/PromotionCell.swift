//
//  PromotionCell.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 12.07.24.
//

import UIKit

class PromotionCell: UICollectionViewCell {
    static let identifier = "PromotionCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .customGreen
        contentView.layer.cornerRadius = 15
        contentView.addSubview(imageView)
        contentView.addSubview(topLabel)
        contentView.addSubview(bottomTextLabel)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            topLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            bottomTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            bottomTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            bottomTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            bottomTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage?, topText: String, bottomText: String) {
        imageView.image = image
        topLabel.text = topText
        bottomTextLabel.text = bottomText
    }
}
