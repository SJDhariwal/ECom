//
//  ProductListViewModelTest.swift
//  eComTests
//
//  Created by Sumit Kumar Jangra on 11/02/25.
//

@testable import eCom
import XCTest
import Combine

final class ProductListViewModelTest: XCTestCase {
    struct ProductListViewModelParameter {
        let productUseCase: ProductUseCaseSpy
        let cartManager: MockCartManager
    }
    
    func makeSUT(
        products: [ProductModel]? = nil,
        productUseCase: ProductUseCaseSpy = ProductUseCaseSpy(),
        cartManager: MockCartManager = MockCartManager(),
        actions: ProductListViewModelActions? = nil
    ) -> (ProductListViewModel, ProductListViewModelParameter) {
        
        let actions = actions ?? ProductListViewModelActions(navigateToProductDetails: { _ in }, navigateToCartList: { })
        let parameter: ProductListViewModelParameter = .init(productUseCase: productUseCase, cartManager: cartManager)
        let sut = ProductListViewModel(
            productUseCase: productUseCase,
            actions: actions,
            cartManager: cartManager
        )
        sut.productList = products
        return (sut, parameter)
    }
    
    func test_givenFetchProductList_whenSucceed_thenShouldUpdateProductList() async throws {
        let (sut, parameter) = makeSUT()
        let productUseCase = parameter.productUseCase
        
        try await sut.fetchProductList()
        let productList = try XCTUnwrap(sut.productList)

        XCTAssertTrue(productUseCase.productListCalled, "Product list always fetch from productUseCase")
        XCTAssertTrue(productList.count > 0, "Product List has multiple product to display")
        XCTAssertEqual(productList, productUseCase.products, "ProductList needs to update with products returned by ProductUseCase")
    }
    
    func test_givenAddToCart_whenProductQuantityIncreased_thenShouldUpdateProductList() async throws {
        let (sut, parameter) = makeSUT(products: [.makeStub(), .makeStub(), .makeStub()])
        
        let productList = try XCTUnwrap(sut.productList)
        var randomProduct = try XCTUnwrap(productList.randomElement())
        
        let quantity = randomProduct.quantity ?? 0
        randomProduct.quantity = quantity + 1
        sut.addToCart(product: randomProduct)
        
        XCTAssertTrue(parameter.cartManager.addToCartCalled, "CartManager add product into cart")
        
        Task {
            let cartProduct = try XCTUnwrap(productList.filter({ $0.id == randomProduct.id }).first)
            let cartProductQuantity = try XCTUnwrap(cartProduct.quantity)

            XCTAssertTrue(cartProductQuantity == 1, "one quantity of product added into cart")
            XCTAssertEqual(cartProduct, randomProduct, "ProductList should update with cart items")
        }
    }
    
    func test_givenRemoveFromCart_whenProductQuantityDecreased_thenShouldUpdateProductList() async throws {
        let (sut, parameter) = makeSUT(products: [.makeStub(), .makeStub(), .makeStub()])
        
        let productList = try XCTUnwrap(sut.productList)
        var randomProduct = try XCTUnwrap(productList.randomElement())
        
        let quantity = randomProduct.quantity ?? 0
        randomProduct.quantity = quantity - 1
        sut.removeFromCart(product: randomProduct)
        
        XCTAssertTrue(parameter.cartManager.removeFromCartCalled, "Cart Manager removed product from cart")
        
        Task {
            let cartProduct = try XCTUnwrap(productList.filter({ $0.id == randomProduct.id }).first)
            let cartProductQuantity = try XCTUnwrap(cartProduct.quantity)
            
            XCTAssertTrue(cartProductQuantity == 0, "one quantity of product removed from cart")
            XCTAssertEqual(cartProduct, randomProduct, "ProductList updated with cart items")
        }
    }
    
    func testNavigateToProductDetail() {
        var navigateToProductDetailCalled = false
        let actions = ProductListViewModelActions(
            navigateToProductDetails: { _ in
                navigateToProductDetailCalled = true
            },
            navigateToCartList: {})
        
        let (sut, _) = makeSUT(actions: actions)
        sut.navigateToProductDetail(with: .makeStub())
        
        XCTAssertTrue(navigateToProductDetailCalled, "navigateToProductDetails action called when product selected")
    }
    
    func testNavigateToCart() {
        var navigateToCartCalled = false
        let actions = ProductListViewModelActions(
            navigateToProductDetails: { _ in
            },
            navigateToCartList: {
            navigateToCartCalled = true
        })
        
        let (sut, _) = makeSUT(actions: actions)
        sut.navigateToCartList()
        
        XCTAssertTrue(navigateToCartCalled, "navigateToCartList action called when cart selected")
    }
}
