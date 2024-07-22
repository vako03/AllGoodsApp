//
//  SharedStorage.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 15.07.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SharedStorage {
    static let shared = SharedStorage()
    
    private let db = Firestore.firestore()
    
    private var userId: String {
        return Auth.auth().currentUser?.uid ?? "defaultUser"
    }

    private(set) var favoriteProductIds: Set<Int> = []
    private(set) var cartProductIds: Set<Int> = []
    private(set) var orders: [Order] = []

    private init() {
        // Load data from Firestore on initialization
        loadFavoritesFromFirestore()
        loadCartFromFirestore()
        loadOrdersFromFirestore()
    }

    // Favorite Products
    func toggleFavorite(productId: Int) {
        if favoriteProductIds.contains(productId) {
            favoriteProductIds.remove(productId)
        } else {
            favoriteProductIds.insert(productId)
        }
        saveFavoritesToFirestore()
        NotificationCenter.default.post(name: .favoritesUpdated, object: productId)
    }

    func isFavorite(productId: Int) -> Bool {
        return favoriteProductIds.contains(productId)
    }

    func getFavoriteProducts(from products: [Product]) -> [Product] {
        return products.filter { favoriteProductIds.contains($0.id) }
    }

    func saveFavoritesToFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        let favoriteData = ["favorites": Array(favoriteProductIds)]
        db.collection("users").document(user.uid).setData(favoriteData, merge: true) { error in
            if let error = error {
                print("Error saving favorites: \(error)")
            }
        }
    }

    func loadFavoritesFromFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        db.collection("users").document(user.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(), let favorites = data["favorites"] as? [Int] {
                    self.favoriteProductIds = Set(favorites)
                    NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
                }
            }
        }
    }

    // Cart Products
    func toggleCart(productId: Int) {
        if cartProductIds.contains(productId) {
            cartProductIds.remove(productId)
        } else {
            cartProductIds.insert(productId)
        }
        saveCartToFirestore()
        NotificationCenter.default.post(name: .cartUpdated, object: productId)
    }

    func isInCart(productId: Int) -> Bool {
        return cartProductIds.contains(productId)
    }

    func getCartProducts(from products: [Product]) -> [Product] {
        return products.filter { cartProductIds.contains($0.id) }
    }

    func saveCartToFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        let cartData = ["cart": Array(cartProductIds)]
        db.collection("users").document(user.uid).setData(cartData, merge: true) { error in
            if let error = error {
                print("Error saving cart: \(error)")
            }
        }
    }

    func loadCartFromFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        db.collection("users").document(user.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(), let cart = data["cart"] as? [Int] {
                    self.cartProductIds = Set(cart)
                    NotificationCenter.default.post(name: .cartUpdated, object: nil)
                }
            }
        }
    }

    func clearCart() {
        cartProductIds.removeAll()
        saveCartToFirestore()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    // Orders
    func addOrder(_ order: Order) {
        orders.append(order)
        saveOrdersToFirestore()
        NotificationCenter.default.post(name: .ordersUpdated, object: order)
    }

    func getOrders() -> [Order] {
        return orders
    }

    private func saveOrdersToFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        let orderData = orders.map { $0.toDictionary() }
        db.collection("users").document(user.uid).setData(["orders": orderData], merge: true) { error in
            if let error = error {
                print("Error saving orders: \(error)")
            } else {
                print("Orders successfully saved to Firestore")
            }
        }
    }

    private func loadOrdersFromFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        db.collection("users").document(user.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(), let orderDicts = data["orders"] as? [[String: Any]] {
                    self.orders = orderDicts.compactMap { Order(dictionary: $0) }
                    NotificationCenter.default.post(name: .ordersUpdated, object: nil)
                    print("Orders successfully loaded from Firestore")
                }
            }
        }
    }
}

extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
    static let cartUpdated = Notification.Name("cartUpdated")
    static let ordersUpdated = Notification.Name("ordersUpdated")
}
