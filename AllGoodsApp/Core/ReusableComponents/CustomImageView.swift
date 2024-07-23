//
//  CustomImageView.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 09.07.24.
//

import UIKit

final class CustomImageView: UIImageView {
    init(image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFit) {
        super.init(frame: .zero)
        self.image = image
        self.contentMode = contentMode
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

