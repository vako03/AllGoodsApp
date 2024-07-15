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

    private init() {
        // Load data from Firestore on initialization
        loadFavoritesFromFirestore()
        loadCartFromFirestore()
    }

    func toggleFavorite(productId: Int) {
        if favoriteProductIds.contains(productId) {
            favoriteProductIds.remove(productId)
        } else {
            favoriteProductIds.insert(productId)
        }
        saveFavoritesToFirestore()
        NotificationCenter.default.post(name: .favoritesUpdated, object: productId)
    }

    func toggleCart(productId: Int) {
        if cartProductIds.contains(productId) {
            cartProductIds.remove(productId)
        } else {
            cartProductIds.insert(productId)
        }
        saveCartToFirestore()
        NotificationCenter.default.post(name: .cartUpdated, object: productId)
    }

    func isFavorite(productId: Int) -> Bool {
        return favoriteProductIds.contains(productId)
    }

    func isInCart(productId: Int) -> Bool {
        return cartProductIds.contains(productId)
    }

    func getFavoriteProducts(from products: [Product]) -> [Product] {
        return products.filter { favoriteProductIds.contains($0.id) }
    }

    func getCartProducts(from products: [Product]) -> [Product] {
        return products.filter { cartProductIds.contains($0.id) }
    }

    private func saveFavoritesToFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        let favoriteData = ["favorites": Array(favoriteProductIds)]
        db.collection("users").document(user.uid).setData(favoriteData, merge: true) { error in
            if let error = error {
                print("Error saving favorites: \(error)")
            }
        }
    }

    private func saveCartToFirestore() {
        guard let user = Auth.auth().currentUser else { return }
        let cartData = ["cart": Array(cartProductIds)]
        db.collection("users").document(user.uid).setData(cartData, merge: true) { error in
            if let error = error {
                print("Error saving cart: \(error)")
            }
        }
    }

    private func loadFavoritesFromFirestore() {
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

    private func loadCartFromFirestore() {
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
}

extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
    static let cartUpdated = Notification.Name("cartUpdated")
}
