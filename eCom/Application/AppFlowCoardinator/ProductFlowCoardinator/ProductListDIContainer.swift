//
//  ProductListDIContainer.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 11/02/25.
//

import UIKit
import SwiftUI

protocol ProductListFlowCoardinatorDependencies {
    func makeProductListViewController(actions: ProductListViewModelActions) -> UIViewController
    func makeProductDetailViewController(product: ProductModel, actions: ProductDetailViewModelActions) -> UIViewController
}

final class ProductListDIContainer: ProductListFlowCoardinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let cartManager: CartManager
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // UseCase
    
    func makeProductUseCase() -> ProductUseCase {
        DefaultProductUseCase(productRepository: makeProductRepository())
    }
    
    // Repository
    
    func makeProductRepository() -> ProductRepository {
        DefaultProductRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    // Scenes
    func makeProductListViewController(
        actions: ProductListViewModelActions
    ) -> UIViewController {
        let productListView = ProductListView(
            viewModel: makeProductListViewModel(actions: actions)
        )
        let productListHostingController = UIHostingController(rootView: productListView)
        return productListHostingController
    }
    
    func makeProductDetailViewController(
        product: ProductModel,
        actions: ProductDetailViewModelActions
    ) -> UIViewController {
        let productDetailView = ProductDetailView(
            viewModel: makeProductDetailViewModel(
                product: product,
                actions: actions
            )
        )
        let productDetailHostingController = UIHostingController(rootView: productDetailView)
        return productDetailHostingController
    }
    
    // ViewModels
    
    func makeProductListViewModel(
        actions: ProductListViewModelActions
    ) -> ProductListViewModel {
        ProductListViewModel(productUseCase: makeProductUseCase(), actions: actions, cartManager: dependencies.cartManager)
    }
    
    func makeProductDetailViewModel(
        product: ProductModel,
        actions: ProductDetailViewModelActions
    ) -> ProductDetailViewModel {
        ProductDetailViewModel(product: product, cartManager: dependencies.cartManager, actions: actions)
    }
    
    // Coardinator
    func makeProductListFlowCoardinator(
        navigatioinController: UINavigationController,
        delegate: ProductListFlowCoardinatorDelegate
    ) -> ProductListFlowCoardinator {
        return ProductListFlowCoardinator(navigationController: navigatioinController, dependencies: self, delegate: delegate)
    }
}
