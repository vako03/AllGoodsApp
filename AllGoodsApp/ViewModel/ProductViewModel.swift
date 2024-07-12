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
}
extension ProductViewModel {
    func fetchAllBrands(completion: @escaping (Result<[String], Error>) -> Void) {
        networkManager.fetchAllBrands(completion: completion)
    }
    
    func fetchProducts(forBrand brand: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        networkManager.fetchProducts(forBrand: brand, completion: completion)
    }
}
