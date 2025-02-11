//
//  ProductModel.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 31/01/25.
//

import Foundation

struct ProductListModel: Decodable, Hashable {
    var products: [ProductModel]
}

struct ProductModel: Decodable, Hashable, Identifiable {
    var id: Int
    var title: String
    var description: String
    var price: Double
    var discountPercentage: Double
    var thumbnail: String
    var quantity: Int?
}

extension ProductModel {
    var imageURL: URL? {
        URL(string: thumbnail)
    }
    
    var isAddedToCart: Bool {
        quantity ?? 0 > 0
    }
}
