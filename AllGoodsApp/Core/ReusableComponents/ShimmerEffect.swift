//
//  ShimmerEffect.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.09.24.
//

import Foundation
import UIKit

import UIKit

class ShimmerEffect {
    static func addShimmer(to view: UIView, duration: TimeInterval = 1.5, delay: TimeInterval = 2.8) {
        let shimmerView = UIView(frame: view.bounds)
        shimmerView.backgroundColor = UIColor.clear
        view.addSubview(shimmerView)
        view.bringSubviewToFront(shimmerView)

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(white: 0.85, alpha: 0.0).cgColor,
            UIColor(white: 0.85, alpha: 0.8).cgColor,
            UIColor(white: 0.85, alpha: 0.0).cgColor,
            UIColor(white: 0.85, alpha: 0.8).cgColor,
            UIColor(white: 0.85, alpha: 0.0).cgColor,
            UIColor(white: 0.85, alpha: 0.8).cgColor,
            UIColor(white: 0.85, alpha: 0.0).cgColor,
            UIColor(white: 0.85, alpha: 0.8).cgColor,
            UIColor(white: 0.85, alpha: 0.0).cgColor
        ]
        gradientLayer.frame = shimmerView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]

        shimmerView.layer.addSublayer(gradientLayer)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
        animation.toValue = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
        animation.duration = duration
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            shimmerView.removeFromSuperview()
        }
    }
}
