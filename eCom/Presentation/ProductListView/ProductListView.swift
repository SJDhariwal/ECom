//
//  ContentView.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 31/01/25.
//

import SwiftUI

struct ProductListView: View {
    @State private var viewModel: ProductListViewModel
    
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            productList
        }
        .navigationTitle("Products")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CartBadgeView(
                    viewModel: .init(cartManager: viewModel.cartManager),
                    cartTapAction: {
                    viewModel.navigateToCartList()
                })
            }
        }
        .onLoad {
            Task {
                try await viewModel.fetchProductList()
            }
        }
    }
    
    private var productList: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    if let products = viewModel.productList {
                        ForEach(products) { product in
                            productRow(product)
                        }
                    }
                }
                .padding(.vertical)
            }
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
        .padding(.horizontal)
        .onTapGesture {
            viewModel.navigateToProductDetail(with: product)
        }
    }
}
