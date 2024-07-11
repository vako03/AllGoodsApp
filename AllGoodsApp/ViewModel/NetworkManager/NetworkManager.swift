//
//  NetworkManager.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}

    func fetchCategories(completion: @escaping ([Category]) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/products/categories") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let categories = try JSONDecoder().decode([Category].self, from: data)
                    completion(categories)
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchProducts(for url: String, completion: @escaping ([Product]) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(ProductResponse.self, from: data)
                    completion(response.products)
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data)
        }.resume()
    }
}
