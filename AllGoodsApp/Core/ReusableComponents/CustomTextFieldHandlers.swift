//
//  CustomTextFieldHandlers.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import UIKit

final class CustomTextFieldHandlers {
    static func handleEmailTextChange(textField: CustomTextField, text: String) {
        textField.rightIconButton.isHidden = !isValidEmail(text)
    }

    static func handlePasswordTextChange(textField: CustomTextField, text: String) {
        textField.rightIconButton.isHidden = text.isEmpty
    }

    static func togglePasswordVisibility(textField: CustomTextField) {
        textField.isSecureTextEntry.toggle()
        let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
        textField.rightIconButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}


import UIKit

class LineFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

    func setupLayout() {
        minimumLineSpacing = 0
        register(LineDecorationView.self, forDecorationViewOfKind: LineDecorationView.kind)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var allAttributes = [UICollectionViewLayoutAttributes]()
        
        attributes?.forEach { attribute in
            allAttributes.append(attribute)
            if attribute.representedElementCategory == .cell {
                let decorationAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: LineDecorationView.kind, with: attribute.indexPath)
                decorationAttributes.frame = CGRect(x: attribute.frame.minX, y: attribute.frame.maxY, width: attribute.frame.width, height: 1)
                decorationAttributes.zIndex = 1
                allAttributes.append(decorationAttributes)
            }
        }
        
        return allAttributes
    }
}

class LineDecorationView: UICollectionReusableView {
    static let kind = "LineDecorationView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .black
    }
}

