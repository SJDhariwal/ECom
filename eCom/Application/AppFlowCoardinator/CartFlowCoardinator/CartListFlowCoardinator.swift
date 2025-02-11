//
//  CartListFlowCoardinator.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 11/02/25.
//
import UIKit

protocol CartFlowCoardinatorDelegate: AnyObject {
    func cartFlowFinished(from coardinator: CartListFlowCoardinator)
}

final class CartListFlowCoardinator {
    private weak var navigationController: UINavigationController?
    private weak var delegate: CartFlowCoardinatorDelegate?
    private let dependencies: CartListFlowCoardinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: CartListFlowCoardinatorDependencies,
        delegate: CartFlowCoardinatorDelegate
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.delegate = delegate
    }
    
    func start() {
        navigateToCartList()
    }
    
    private func navigateToCartList() {
        let actions = CartViewModelActions(navigateToConfirmation: navigateToConfirmation)
        let cartListVC = dependencies.makeCartViewController(actions: actions)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.pushViewController(cartListVC, animated: true)
    }
    
    private func navigateToConfirmation() {
        let actions = ConfirmationViewModelActions(cartFlowFinished: cartFlowFinished)
        let confirmationVC = dependencies.makeConfirmationViewController(actions: actions)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.pushViewController(confirmationVC, animated: true)
    }
    
    private func cartFlowFinished() {
        self.navigationController?.popToRootViewController(animated: true)
        self.delegate?.cartFlowFinished(from: self)
    }
}
