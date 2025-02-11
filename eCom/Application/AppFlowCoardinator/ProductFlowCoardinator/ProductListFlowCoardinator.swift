//
//  ProductListFlowCoardinator.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 11/02/25.
//

import UIKit

protocol ProductListFlowCoardinatorDelegate: AnyObject {
    func didRequestCartFlow(from coardinator: ProductListFlowCoardinator)
}

final class ProductListFlowCoardinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: ProductListFlowCoardinatorDependencies
    private weak var delegate: ProductListFlowCoardinatorDelegate?
    
    init(
        navigationController: UINavigationController,
        dependencies: ProductListFlowCoardinatorDependencies,
        delegate: ProductListFlowCoardinatorDelegate
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.delegate = delegate
    }
    
    func start() {
        navigateToProductList()
    }
    
    private func navigateToProductList() {
        let actions = ProductListViewModelActions(
            navigateToProductDetails: navigateToProductDetails,
            navigateToCartList: navigateToCartList
        )
        let productListVC = dependencies.makeProductListViewController(actions: actions)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.pushViewController(productListVC, animated: false)
    }
    
    private func navigateToProductDetails(product: ProductModel) {
        let actions = ProductDetailViewModelActions(navigateToCartList: navigateToCartList)
        let productDetailVC = dependencies.makeProductDetailViewController(product: product, actions: actions)
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    private func navigateToCartList() {
        self.delegate?.didRequestCartFlow(from: self)
    }
}
