//
//  SharedStorage.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 15.07.24.
//

import Foundation

class SharedStorage {
    static let shared = SharedStorage()

    private(set) var favoriteProductIds: Set<Int> = []
    private(set) var cartProductIds: Set<Int> = []

    private init() {}

    func toggleFavorite(productId: Int) {
        if favoriteProductIds.contains(productId) {
            favoriteProductIds.remove(productId)
        } else {
            favoriteProductIds.insert(productId)
        }
        NotificationCenter.default.post(name: .favoritesUpdated, object: productId)
    }

    func toggleCart(productId: Int) {
        if cartProductIds.contains(productId) {
            cartProductIds.remove(productId)
        } else {
            cartProductIds.insert(productId)
        }
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
}

extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
    static let cartUpdated = Notification.Name("cartUpdated")
}
