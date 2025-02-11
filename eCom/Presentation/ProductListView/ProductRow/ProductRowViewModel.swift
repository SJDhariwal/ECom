//
//  ProductRowViewModel.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 11/02/25.
//
import Observation

@Observable
class ProductRowViewModel {
    var product: ProductModel
    
    private let addCartAction: (ProductModel) -> Void
    private let removeCartAction: (ProductModel) -> Void
    
    init(product: ProductModel,
        addCartAction: @escaping (ProductModel) -> Void,
        removeCartAction: @escaping (ProductModel) -> Void
    ) {
        self.product = product
        self.addCartAction = addCartAction
        self.removeCartAction = removeCartAction
    }
    
    func incrementQuantityByOne() {
        if let quantity = product.quantity {
            product.quantity = quantity + 1
        } else {
            product.quantity = 1
        }
        addCartAction(product)
    }
    
    func decrementQuantityByOne() {
        if let quantity = product.quantity, quantity > 0 {
            product.quantity = quantity - 1
            removeCartAction(product)
        }
    }
}
