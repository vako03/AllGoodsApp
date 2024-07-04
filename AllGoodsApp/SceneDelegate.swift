//
//  SceneDelegate.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 03.07.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let coordinator = AppCoordinator(window: window!)
        coordinator.start()
    }
}
