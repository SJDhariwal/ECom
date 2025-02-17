//
//  CartManagerTest.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 16/02/25.
//

@testable import eCom
import XCTest
import Combine

final class CartManagerTest: XCTestCase {
    private var cancellable = Set<AnyCancellable>()
    
    func makeSUT() -> CartManager {
        let cartManager = DefaultCartManager()
        return cartManager
    }
    // Requirement
    
    // addToCart Should add new product into Cart when item quantity 1
    // addToCart Should not add product into Cart when item quantity < 0
    // addToCart Should not add product into Cart when item quantity == 0
    // addToCart Should not add product into Cart when item quantity is nil
    
    // cartItems count should increase when new product added into cart
    // cartItems should not contain duplicate products
    // addToCart should increase productQuantity for any existing product
    // cartItems count should increase when any existing product quantity increased
    
    // removeFromCart Should remove product from Cart when item quantity > 0
    // removeFromCart Should not remove product from Cart when item quantity < 0
    // removeFromCart Should remove product from Cart when item quantity == 0
    // removeFromCart Should not remove product from Cart when item quantity is nil
    
    // cartItems count should decrease when product removed from cart
    // cartItems count should decrease when any existing product quantity decreased
    // no impact on cartItems when product not found in cart
    
    // no race condition should occur when multiple addToCart and removeFromCart executed
    // Race condition should be occur when CartManager changed from actor to class

    
    func test_givenAddToCart_whenNewProductAdded_thenShouldUpdateCart() {
        let sut = makeSUT()
        var product: ProductModel = .makeStub()
        var cartItemsInfoSubscriberCalled = false
        
        product.quantity = 1
        sut.addToCart(item: product)
        sut.cartItemsInfo.sink { (items, item) in
            cartItemsInfoSubscriberCalled = true
            let quantity = try? XCTUnwrap(item?.quantity, "Item with nil quantity can't be present in cart")
            XCTAssertEqual(quantity, 1, "New product added into cart should have quantity 1")
            XCTAssertEqual(items.count, 1, "Cart Count should match items present into cart")
        }
        .store(in: &cancellable)
        
        XCTAssertTrue(cartItemsInfoSubscriberCalled, "cartItemInfo failed to send cart update after addToCart")
    }
}
