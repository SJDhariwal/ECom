//
//  MockProductUseCase.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 13/02/25.
//

@testable import eCom

class MockProductUseCase: ProductUseCase {
    var productListCalled: Bool = false
    var result: Result<ProductListModel, any Error>!
    
    func execute() async throws -> Result<ProductListModel, any Error> {
        productListCalled = true
        return result
    }
}
