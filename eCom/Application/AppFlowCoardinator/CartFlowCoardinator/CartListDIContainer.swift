//
//  CartListDIContainer.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 11/02/25.
//

import UIKit
import SwiftUI


protocol CartListFlowCoardinatorDependencies {
    func makeCartViewController(actions: CartViewModelActions) -> UIViewController
    func makeAddressViewController() -> UIViewController
    func makeConfirmationViewController(actions: ConfirmationViewModelActions) -> UIViewController
}

final class CartListDIContainer: CartListFlowCoardinatorDependencies {
    struct Dependencies {
        let cartManager: CartManager
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // Scenes
    func makeCartViewController(actions: CartViewModelActions) -> UIViewController {
        let cartListView = CartView(viewModel: makeCartListViewModel(actions: actions))
        let cartListHostingController = UIHostingController(rootView: cartListView)
        return cartListHostingController
    }
    
    func makeAddressViewController() -> UIViewController {
        UIViewController()
    }
    
    // ViewModel
    func makeCartListViewModel(actions: CartViewModelActions) -> CartViewModel {
        CartViewModel(cartManager: dependencies.cartManager, actions: actions)
    }
    
    func makeConfirmationViewModel(actions: ConfirmationViewModelActions) -> ConfirmationViewModel {
        ConfirmationViewModel(actions: actions, cartManager: dependencies.cartManager)
    }
    
    func makeConfirmationViewController(actions: ConfirmationViewModelActions) -> UIViewController {
        let confirmationView = ConfirmationView(viewModel: makeConfirmationViewModel(actions: actions))
        let confirmationHostingController = UIHostingController(rootView: confirmationView)
        return confirmationHostingController
    }
    
    // Coardinator
    func makeCartListFlowCoardinator(
        navigatioinController: UINavigationController,
        delegate: CartFlowCoardinatorDelegate
    ) -> CartListFlowCoardinator {
        return CartListFlowCoardinator(
            navigationController: navigatioinController,
            dependencies: self,
            delegate: delegate
        )
    }
    
}

