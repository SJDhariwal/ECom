//
//  CartView.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 31/01/25.
//

import SwiftUI

struct CartView: View {
    @State private var viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack {
            productList
            placeOrder
        }
        .navigationTitle("Cart List")
    }
    
    private var placeOrder: some View {
        Button {
            viewModel.navigateToConfirmation()
        } label: {
            Text("Place Order")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(12)
        }
        .padding()
    }
    
    private var productList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.cartItems) { product in
                    productRow(product)
                }
            }
            .padding()
        }
    }
    
    private func productRow(_ product: ProductModel) -> some View {
        ProductRow(
            viewModel: ProductRowViewModel(
                product: product,
                addCartAction: { product in
                    viewModel.addToCart(product: product)
                },
                removeCartAction: { product in
                    viewModel.removeFromCart(product: product)
                }
            )
        )
    }
}
