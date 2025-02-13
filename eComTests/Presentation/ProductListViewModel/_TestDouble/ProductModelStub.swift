//
//  ProductModelStub.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 13/02/25.
//

@testable import eCom
import Foundation

extension ProductModel {
    static func makeStub(
        id: Int = Int.random(in: 1...100),
        title: String = UUID().uuidString,
        description: String = UUID().uuidString,
        price: Double = 0,
        discountPercentage: Double = 0,
        thumbnail: String = UUID().uuidString
    ) -> ProductModel {
        ProductModel(
            id: id,
            title: title,
            description: description,
            price: price,
            discountPercentage: discountPercentage,
            thumbnail: thumbnail
        )
    }
}
