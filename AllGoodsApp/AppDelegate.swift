//
//  AppDelegate.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 03.07.24.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        // Clear UserDefaults to reset state on app reinstall
        if !UserDefaults.standard.bool(forKey: "isFirstLaunchCompleted") {
            UserDefaults.standard.set(true, forKey: "isFirstLaunchCompleted")
            UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
        }

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()

        return true
    }
}
