//
//  CustomTextField.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import UIKit

class CustomTextField: UITextField {
    let underline: UIView
    let rightIconButton: UIButton
    
    init(placeholder: String, isSecure: Bool = false, rightIconImage: UIImage? = nil) {
        self.underline = UIView()
        self.rightIconButton = UIButton(type: .custom)
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.borderStyle = .none
        self.isSecureTextEntry = isSecure
        self.translatesAutoresizingMaskIntoConstraints = false
        
        underline.backgroundColor = .black
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = rightIconImage {
            rightIconButton.setImage(image, for: .normal)
            rightIconButton.tintColor = .black
            rightIconButton.translatesAutoresizingMaskIntoConstraints = false
            rightIconButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.rightView = rightIconButton
            self.rightViewMode = .always
        }
        
        addSubview(underline)
        NSLayoutConstraint.activate([
            underline.heightAnchor.constraint(equalToConstant: 1),
            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
