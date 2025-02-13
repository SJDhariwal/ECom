//
//  MockCartManager.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 13/02/25.
//
@testable import eCom
import Combine


class MockCartManager: CartManager {
    var _cartItems = CurrentValueSubject<([ProductModel], ProductModel?), Never>(([], nil))
    var cartItemsInfo: AnyPublisher<([ProductModel], ProductModel?), Never> {
        _cartItems.eraseToAnyPublisher()
    }
    
    var addToCartCalled = false
    var removeFromCartCalled = false
    var resetCartCalled = false
    
    func addToCart(item: ProductModel) {
        addToCartCalled = true
        _cartItems.send(([item], item))
    }
    
    func removeFromCart(item: ProductModel) {
        removeFromCartCalled = true
        _cartItems.send(([item], item))
    }
    
    func resetCart() {
        resetCartCalled = true
        _cartItems.send(([], nil))
    }
}
