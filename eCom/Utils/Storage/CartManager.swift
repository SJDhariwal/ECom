//
//  CartManager.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 05/02/25.
//

import Combine
protocol CartManager {
    var cartItemsInfo: AnyPublisher<([ProductModel], ProductModel?), Never> { get }

    func addToCart(item: ProductModel)
    func removeFromCart(item: ProductModel)
    func resetCart()
}

actor DefaultCartManager: @preconcurrency CartManager {
    private var cartItems = [ProductModel]()
    private var _cartItems = CurrentValueSubject<([ProductModel], ProductModel?), Never>(([], nil))

    var cartItemsInfo: AnyPublisher<([ProductModel], ProductModel?), Never> { _cartItems.eraseToAnyPublisher() }

    func addToCart(item: ProductModel) {
        guard let quantity = item.quantity, quantity > 0 else { return }
        
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index] = item
        } else {
            cartItems.append(item)
        }
        
        _cartItems.send((cartItems, item))
    }
    
    func removeFromCart(item: ProductModel) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if let quantity = item.quantity, quantity <= 0 {
                cartItems.remove(at: index)
            } else {
                cartItems[index] = item
            }
            _cartItems.send((cartItems, item))
        }
    }
    
    func resetCart() {
        cartItems.removeAll()
        _cartItems.send((cartItems, nil))
    }
}
