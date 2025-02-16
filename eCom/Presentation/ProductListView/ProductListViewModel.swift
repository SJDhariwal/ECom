//
//  ProductListViewModel.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 31/01/25.
//
import Foundation
import Combine

struct ProductListViewModelActions {
    let navigateToProductDetails: (ProductModel) -> Void
    let navigateToCartList: () -> Void
}

@Observable
class ProductListViewModel {
    private let productUseCase: ProductUseCase
    private let actions: ProductListViewModelActions
    private var cancellable = Set<AnyCancellable>()

    let cartManager: CartManager
    
    var products: [ProductModel]? {
        didSet {
            productList = products
        }
    }
    var productList: [ProductModel]?

    init(
        productUseCase: ProductUseCase,
        actions: ProductListViewModelActions,
        cartManager: CartManager
    ) {
        self.productUseCase = productUseCase
        self.actions = actions
        self.cartManager = cartManager
        self.subscribeToCartUpdate()
    }
    
    private func subscribeToCartUpdate() {
        cartManager.cartItemsInfo
            .sink { [weak self] (cartItems, item) in
                guard let self else { return }
                guard cartItems.count > 0 else {
                    self.productList = self.products
                    return
                }
                if let item, let index = self.productList?.firstIndex(where: { $0.id == item.id }) {
                    self.productList?[index] = item
                }
            }
            .store(in: &cancellable)
    }
    
    @MainActor
    func fetchProductList() async throws {
        let result = try await productUseCase.execute()
        switch result {
        case .success(let productList):
            self.products = productList.products
            
        case .failure:
            break
        }
    }
    
    func addToCart(product: ProductModel) {
        cartManager.addToCart(item: product)
    }
    
    func removeFromCart(product: ProductModel) {
        cartManager.removeFromCart(item: product)
    }
    
    func navigateToProductDetail(with product: ProductModel) {
        actions.navigateToProductDetails(product)
    }
    
    func navigateToCartList() {
        actions.navigateToCartList()
    }
    
}
