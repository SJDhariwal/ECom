//
//  CartViewModel.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 31/01/25.
//

import Combine
import Observation

struct CartViewModelActions {
    let navigateToConfirmation: () -> Void
}

@Observable
class CartViewModel {
    private let cartManager: CartManager
    private let actions: CartViewModelActions
    private var cancellable = Set<AnyCancellable>()
    
    var cartItems = [ProductModel]()
    
    init(cartManager: CartManager, actions: CartViewModelActions) {
        self.cartManager = cartManager
        self.actions = actions
        self.subscribeToCartOperations()
    }
    
    func subscribeToCartOperations() {
        let cartItemsInfoCancellable = cartManager.cartItemsInfo
            .sink { [weak self] (cartItems, _) in
                guard let self else { return }
                self.cartItems = cartItems
            }
        cancellable.insert(cartItemsInfoCancellable)
    }
    
    func addToCart(product: ProductModel) {
        cartManager.addToCart(item: product)
    }
    
    func removeFromCart(product: ProductModel) {
        cartManager.removeFromCart(item: product)
    }
    
    func navigateToConfirmation() {
        actions.navigateToConfirmation()
    }
}
