//
//  TabBarController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 10.07.24.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - Properties
    private var middleButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        customizeTabBarAppearance()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(middleButton)

        let middleButtonSize = middleButton.frame.size
        let middleButtonY = tabBar.frame.origin.y - (middleButtonSize.height / 2) + 5  
        let middleButtonX = (view.bounds.width - middleButtonSize.width) / 2
        middleButton.frame.origin = CGPoint(x: middleButtonX, y: middleButtonY)
    }

    // MARK: - Setup Middle Button
    private func setupMiddleButton() {
        middleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        middleButton.backgroundColor = .systemGreen
        middleButton.layer.cornerRadius = middleButton.frame.height / 2
        middleButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        middleButton.tintColor = .white
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        middleButton.layer.shadowRadius = 5
        middleButton.layer.shadowOpacity = 0.3

        middleButton.addAction(UIAction { [weak self] _ in
            self?.selectedIndex = 2
        }, for: .touchUpInside)

        view.addSubview(middleButton)
    }

    // MARK: - Customize Tab Bar Appearance
    private func customizeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
