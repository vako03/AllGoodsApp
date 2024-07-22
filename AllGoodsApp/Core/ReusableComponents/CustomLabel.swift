//
//  CustomLabel.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import UIKit

final class CustomLabel: UILabel {
    init(text: String, fontSize: CGFloat = 14, textColor: UIColor = .black, alignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.textAlignment = alignment
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
