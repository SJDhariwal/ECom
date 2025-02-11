//
//  ConfirmationViewModel.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 31/01/25.
//

import Observation

struct ConfirmationViewModelActions {
    let cartFlowFinished: () -> Void
}

@Observable
class ConfirmationViewModel {
    private let actions: ConfirmationViewModelActions
    private let cartManager: CartManager
    
    init(actions: ConfirmationViewModelActions, cartManager: CartManager) {
        self.actions = actions
        self.cartManager = cartManager
    }
    
    func cartFlowFinished() {
        cartManager.resetCart()
        actions.cartFlowFinished()
    }
}
