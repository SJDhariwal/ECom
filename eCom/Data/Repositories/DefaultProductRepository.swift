//
//  DefaultProductRepository.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 02/02/25.
//

import Foundation

protocol ProductRepository {
    func fetchProductList() async throws -> Result<ProductListModel, Error>
}

final class DefaultProductRepository: ProductRepository {
    let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func fetchProductList() async throws -> Result<ProductListModel, Error> {
        let endpoint = ApiEndpoints.getProductList()
        let result = try await dataTransferService.request(with: endpoint)
        switch result {
        case .success(let productList):
            return .success(productList)
        case .failure(let error):
            return .failure(error)
        }
    }
}
