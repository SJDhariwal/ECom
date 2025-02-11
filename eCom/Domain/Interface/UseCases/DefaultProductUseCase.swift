//
//  ProductListUseCase.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 02/02/25.
//

import Foundation

protocol ProductUseCase {
    func execute() async throws -> Result<ProductListModel, Error>
}

final class DefaultProductUseCase: ProductUseCase {
    let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    func execute() async throws -> Result<ProductListModel, Error> {
        let productList = try await productRepository.fetchProductList()
        return productList
    }
}
