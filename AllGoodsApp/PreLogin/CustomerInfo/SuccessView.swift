//
//  SuccessView.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 22.07.24.
//
//
import SwiftUI

struct SuccessView: View {
    var orderNumber: String

    var body: some View {
        VStack {
            Text("Payment Successful!")
                .font(.largeTitle)
                .padding()
            Text("Thank you for your purchase.")
                .font(.headline)
                .padding()
            Text("Your order number is \(orderNumber).")
                .font(.headline)
                .padding()

            Button(action: {
                // Clear the cart
                SharedStorage.shared.clearCart()

                // Navigate to the MainViewController with the tab bar
                let mainVC = MainViewController()
                let favouriteVC = FavouriteViewController()
                let expressVC = ExpressViewController(viewModel: ProductViewModel())
                let basketVC = BasketViewController()
                let profileVC = ProfileViewController()

                mainVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), tag: 0)
                favouriteVC.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart"), tag: 1)
                expressVC.tabBarItem = UITabBarItem(title: "", image: nil, tag: 2)
                basketVC.tabBarItem = UITabBarItem(title: "Basket", image: UIImage(systemName: "cart"), tag: 3)
                profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)

                let tabBarController = TabBarController()
                tabBarController.viewControllers = [mainVC, favouriteVC, expressVC, basketVC, profileVC]
                tabBarController.setValue(TabBar(), forKey: "tabBar")

                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UINavigationController(rootViewController: tabBarController)
                    window.makeKeyAndVisible()
                }
            }) {
                Text("Go to Main Page")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}
