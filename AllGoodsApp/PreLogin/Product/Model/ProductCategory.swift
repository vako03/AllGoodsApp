//
//  ProductCategory.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//

    import Foundation

    struct Product: Codable {
        let id: Int
        let title: String
        let description: String
        let price: Double
        let discountPercentage: Double
        let rating: Double
        let stock: Int
        let brand: String?
        let category: String
        let thumbnail: String
        let images: [String]
        let tags: [String]?
        let sku: String?
        let weight: Double?
        let dimensions: Dimensions?
        let warrantyInformation: String?
        let shippingInformation: String?
        let availabilityStatus: String?
        let reviews: [Review]?
        let returnPolicy: String?
        let minimumOrderQuantity: Int?
        let meta: Meta?
    }

struct Dimensions: Codable {
    let width: Double
    let height: Double
    let depth: Double
}

struct Review: Codable {
    let rating: Int
    let comment: String
    let date: String
    let reviewerName: String
    let reviewerEmail: String
}

struct Meta: Codable {
    let createdAt: String
    let updatedAt: String
    let barcode: String
    let qrCode: String
}

struct ProductResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}


struct CartProduct: Identifiable {
    var id: Int { product.id }
    var product: Product
    var quantity: Int
}



struct Order {
    let orderNumber: String
    let productThumbnail: String
    let customerEmail: String
    let customerPhoneNumber: String
    let date: String
    let amount: String

    init(orderNumber: String, productThumbnail: String, customerEmail: String, customerPhoneNumber: String, date: String, amount: String) {
        self.orderNumber = orderNumber
        self.productThumbnail = productThumbnail
        self.customerEmail = customerEmail
        self.customerPhoneNumber = customerPhoneNumber
        self.date = date
        self.amount = amount
    }

    init?(dictionary: [String: Any]) {
        guard
            let orderNumber = dictionary["orderNumber"] as? String,
            let productThumbnail = dictionary["productThumbnail"] as? String,
            let customerEmail = dictionary["customerEmail"] as? String,
            let customerPhoneNumber = dictionary["customerPhoneNumber"] as? String,
            let date = dictionary["date"] as? String,
            let amount = dictionary["amount"] as? String
        else { return nil }
        
        self.orderNumber = orderNumber
        self.productThumbnail = productThumbnail
        self.customerEmail = customerEmail
        self.customerPhoneNumber = customerPhoneNumber
        self.date = date
        self.amount = amount
    }

    func toDictionary() -> [String: Any] {
        return [
            "orderNumber": orderNumber,
            "productThumbnail": productThumbnail,
            "customerEmail": customerEmail,
            "customerPhoneNumber": customerPhoneNumber,
            "date": date,
            "amount": amount
        ]
    }
}
