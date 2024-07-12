//
//  NetworkManager.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://dummyjson.com/products"
    private let categoriesURL = "YOUR_MOCKY_URL_HERE" // Replace with your Mocky URL
    private init() {}

    func fetchAllProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        var allProducts: [Product] = []
        var skip = 0
        func fetchNextPage() {
            let urlString = "\(baseURL)?limit=30&skip=\(skip)"
            guard let url = URL(string: urlString) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                do {
                    let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                    allProducts.append(contentsOf: productResponse.products)
                    if productResponse.skip + productResponse.limit < productResponse.total {
                        skip += productResponse.limit
                        fetchNextPage()
                    } else {
                        completion(.success(allProducts))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        fetchNextPage()
    }
    
    func fetchProducts(for category: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        let urlString = "\(baseURL)/category/\(category)"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                completion(.success(productResponse.products))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchCategoryImages(completion: @escaping (Result<[String: String], Error>) -> Void) {
        guard let url = URL(string: categoriesURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let categoryImagesResponse = try JSONDecoder().decode([String: [String: String]].self, from: data)
                if let categoryImages = categoryImagesResponse["categories"] {
                    completion(.success(categoryImages))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
