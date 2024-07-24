//
//  ProductViewModel.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//

import Foundation

class ProductViewModel {
    private let networkManager = NetworkManager.shared
    private(set) var products: [Product] = []
    private(set) var productsByCategory: [String: [Product]] = [:]
    private(set) var categoryImages: [String: String] = [:]
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdated), name: .favoritesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCartUpdated), name: .cartUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Fetch Methods
    func fetchAllProducts(completion: @escaping (Result<Void, Error>) -> Void) {
        networkManager.fetchAllProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                self?.categorizeProducts(products)
                self?.setCategoryImages()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchProducts(for category: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        networkManager.fetchProducts(for: category) { result in
            completion(result)
        }
    }

    func fetchAllBrands(completion: @escaping (Result<[String], Error>) -> Void) {
        networkManager.fetchAllBrands { result in
            completion(result)
        }
    }

    func fetchProducts(forBrand brand: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        networkManager.fetchProducts(forBrand: brand) { result in
            completion(result)
        }
    }

    // MARK: - Sorting Methods
    func sortedProductsByDiscount() -> [Product] {
        return products.sorted { $0.discountPercentage > $1.discountPercentage }
    }

    func sortedProductsByRating() -> [Product] {
        return products.sorted { $0.rating > $1.rating }
    }

    // MARK: - Categorization Methods
    private func categorizeProducts(_ products: [Product]) {
        productsByCategory = Dictionary(grouping: products, by: { $0.category })
    }

    private func setCategoryImages() {
        for (category, products) in productsByCategory {
            if let firstProduct = products.first {
                categoryImages[category] = firstProduct.thumbnail
            }
        }
    }

    // MARK: - Favorite Actions
    func toggleFavorite(productId: Int) {
        SharedStorage.shared.toggleFavorite(productId: productId)
        NotificationCenter.default.post(name: .favoritesUpdated, object: productId)
    }

    func isFavorite(productId: Int) -> Bool {
        return SharedStorage.shared.isFavorite(productId: productId)
    }

    // MARK: - Cart Actions
    func toggleCart(productId: Int) {
        SharedStorage.shared.toggleCart(productId: productId)
        NotificationCenter.default.post(name: .cartUpdated, object: productId)
    }

    func isInCart(productId: Int) -> Bool {
        return SharedStorage.shared.isInCart(productId: productId)
    }

    // MARK: - Fetch Favorite and Cart Products
    func getFavoriteProducts() -> [Product] {
        return SharedStorage.shared.getFavoriteProducts(from: products)
    }

    func getCartProducts() -> [CartProduct] {
        return SharedStorage.shared.getCartProducts(from: products).map { CartProduct(product: $0, quantity: 1) }
    }

    // MARK: - Notification Handlers
    @objc private func handleFavoritesUpdated(notification: Notification) {
        if let productId = notification.object as? Int {
            updateProductState(productId: productId)
        }
    }

    @objc private func handleCartUpdated(notification: Notification) {
        if let productId = notification.object as? Int {
            updateProductState(productId: productId)
        }
    }

    private func updateProductState(productId: Int) {
        
    }
}
