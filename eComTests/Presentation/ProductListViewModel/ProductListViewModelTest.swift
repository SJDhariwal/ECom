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
        let productUseCase: MockProductUseCase
        let cartManager: MockCartManager
    }
    
    func makeSUT(
        products: [ProductModel]? = nil,
        productUseCase: MockProductUseCase = MockProductUseCase(),
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
        sut.products = products
        return (sut, parameter)
    }
    
    func test_givenFetchProductList_whenSucceed_thenShouldUpdateProductList() async throws {
        let (sut, parameter) = makeSUT()
        
        let productUseCase = parameter.productUseCase
        let products: [ProductModel] = [.makeStub(), .makeStub(), .makeStub(), .makeStub()]
        productUseCase.result = .success(.init(products: products))
        
        try await sut.fetchProductList()
        let productList = try XCTUnwrap(sut.productList)

        XCTAssertTrue(productUseCase.productListCalled, "Product list always fetch from productUseCase")
        XCTAssertTrue(productList.count == 4, "productList contain 4 products after fetching")
        XCTAssertEqual(productList, products, "ProductList needs to update with products returned by ProductUseCase")
    }
    
    func test_givenAddToCart_whenProductQuantityIncreased_thenShouldUpdateProductList() async throws {
        let (sut, parameter) = makeSUT(products: [.makeStub(), .makeStub(), .makeStub()])
        
        var randomProduct = try XCTUnwrap(sut.productList?.randomElement())
        
        let quantity = randomProduct.quantity ?? 0
        randomProduct.quantity = quantity + 1
        sut.addToCart(product: randomProduct)
        
        XCTAssertTrue(parameter.cartManager.addToCartCalled, "CartManager addToCart called successfully")
        
        let cartProduct = try XCTUnwrap(
            sut.productList?.filter({ $0.id == randomProduct.id }).first,
            "Product List doesn't contain product added into cart"
        )
        
        XCTAssertEqual(cartProduct, randomProduct, "ProductList update with cart items")
    }
    
    func test_givenRemoveFromCart_whenProductQuantityDecreased_thenShouldUpdateProductList() async throws {
        let (sut, parameter) = makeSUT(products: [.makeStub(), .makeStub(), .makeStub()])
        
        var randomProduct = try XCTUnwrap(sut.productList?.randomElement())
        
        let quantity = randomProduct.quantity ?? 0
        randomProduct.quantity = quantity - 1
        sut.removeFromCart(product: randomProduct)
        
        XCTAssertTrue(parameter.cartManager.removeFromCartCalled, "CartManager removeFromCart called successfully")
        
        let cartProduct = try XCTUnwrap(
            sut.productList?.filter({ $0.id == randomProduct.id }).first,
            "Product List doesn't contain product removed from cart"
        )

        XCTAssertEqual(cartProduct, randomProduct, "ProductList should update with cart items")
    }
    
    func test_givenResetCart_thenShouldUpdateProductList() async throws {
        let (sut, _) = makeSUT(products: [.makeStub(), .makeStub(), .makeStub()])
        
        var randomProduct = try XCTUnwrap(sut.productList?.randomElement())
        let quantity = randomProduct.quantity ?? 0
        randomProduct.quantity = quantity + 1
        sut.addToCart(product: randomProduct)
        
        XCTAssertNotEqual(sut.productList, sut.products, "Afert addToCart, productList no longer same to original products")
        sut.cartManager.resetCart()

        XCTAssertEqual(sut.productList, sut.products, "After cart reset, productList update with original products")
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
        
        XCTAssertTrue(navigateToProductDetailCalled, "navigateToProductDetails action called successfully")
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
        
        XCTAssertTrue(navigateToCartCalled, "navigateToCartList action called successfully")
    }
}
