//
//  AppDelegate.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 03.07.24.
//

import UIKit
import Firebase
import GoogleMaps

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyDaCYMQN2aKgRmbBODXHXXZ3mBYruiPFk0")

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()

        return true
    }
}
