//
//  ProductUseCaseSpy.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 13/02/25.
//

@testable import eCom

class ProductUseCaseSpy: ProductUseCase {
    var productListCalled: Bool = false
    var products: [ProductModel] = [.makeStub(), .makeStub(), .makeStub(), .makeStub()]
    
    func execute() async throws -> Result<ProductListModel, any Error> {
        productListCalled = true
        return .success(.init(products: products))
    }
}
