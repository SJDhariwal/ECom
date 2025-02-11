//
//  ProductDetailViewModel.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 31/01/25.
//
import Combine
import Observation

struct ProductDetailViewModelActions {
    let navigateToCartList: () -> Void
}

@Observable
class ProductDetailViewModel {
    var product: ProductModel
    let cartManager: CartManager
    private let actions: ProductDetailViewModelActions
    private var cancellable = Set<AnyCancellable>()
    
    init(product: ProductModel, cartManager: CartManager, actions: ProductDetailViewModelActions) {
        self.product = product
        self.cartManager = cartManager
        self.actions = actions
        self.subscribeToCartUpdates()
    }
    
    func addToCart() {
        cartManager.addToCart(item: product)
    }
    
    func removeFromCart() {
        cartManager.removeFromCart(item: product)
    }
    
    func incrementQuantityByOne() {
        if let quantity = product.quantity {
            product.quantity = quantity + 1
        } else {
            product.quantity = 1
        }
    }
    
    func decrementQuantityByOne() {
        if let quantity = product.quantity, quantity > 0 {
            product.quantity = quantity - 1
        }
    }
    
    func subscribeToCartUpdates() {
        let cartItemsInfoCancellable = cartManager.cartItemsInfo
            .filter({ $1?.id == self.product.id })
            .sink { [weak self] (_, item) in
                guard let self, let item else { return }
                self.product = item
            }
        cancellable.insert(cartItemsInfoCancellable)
    }
    
    func navigateToCart() {
        actions.navigateToCartList()
    }
}

