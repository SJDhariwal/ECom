//
//  CartBadgeViewModel.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 05/02/25.
//

import Combine
class CartBadgeViewModel: ObservableObject {
    @Published var cartCount: Int = 0

    private let cartManager: CartManager
    private var cancellable = Set<AnyCancellable>()
    
    init(cartManager: CartManager) {
        self.cartManager = cartManager
        self.subscribeToCartOperation()
    }
    
    private func subscribeToCartOperation() {
        let cartItemsInfoCancellable = cartManager.cartItemsInfo
            .sink { [weak self] (cartItems, _) in
                guard let self else { return }
                self.cartCount = cartItems.reduce(0, { $0 + ($1.quantity ?? 0) })
            }
        cancellable.insert(cartItemsInfoCancellable)
    }
}

