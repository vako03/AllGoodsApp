//
//  ProductCategory.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//

struct Category: Codable {
    let name: String
    let url: String
}

struct Product: Codable {
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: String
}

struct ProductResponse: Codable {
    let products: [Product]
}

