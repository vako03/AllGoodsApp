//
//  CategoryViewModel.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//

import Foundation

class CategoryViewModel {
    private(set) var categories: [Category] = []
    
    func fetchCategories(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchCategories { [weak self] categories in
            self?.categories = categories
            completion()
        }
    }
}

class ProductListViewModel {
    private(set) var products: [Product] = []
    
    func fetchProducts(for url: String, completion: @escaping () -> Void) {
        NetworkManager.shared.fetchProducts(for: url) { [weak self] products in
            self?.products = products
            completion()
        }
    }
}
