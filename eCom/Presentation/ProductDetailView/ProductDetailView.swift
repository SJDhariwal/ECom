//
//  ProductDetailView.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 31/01/25.
//

import SwiftUI

struct ProductDetailView: View {
    @State private var viewModel: ProductDetailViewModel
    
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            image
            title
            description
            HStack {
                price
                Spacer()
                quantity
            }
            addToCart
            Spacer()
        }
        .padding()
        .navigationTitle("Product Details")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CartBadgeView(viewModel: .init(cartManager: viewModel.cartManager), cartTapAction: {
                    viewModel.navigateToCart()
                })
            }
        }
    }
    
    private var image: some View {
        AsyncCacheImage(url: viewModel.product.imageURL)
            .frame(height: 300)
            .cornerRadius(12)
    }
    
    private var title: some View {
        Text(viewModel.product.title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .lineLimit(2)
    }
    
    private var description: some View {
        Text(viewModel.product.description)
            .font(.body)
            .foregroundStyle(.secondary)
    }
    
    private var price: some View {
        Text("Price: $ \(viewModel.product.price, specifier: "%.0f")")
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    private var quantity: some View {
        QuantityView(
            quantity: viewModel.product.quantity ?? 0,
            decrement: {
                viewModel.decrementQuantityByOne()
                viewModel.removeFromCart()
            },
            increment: {
                viewModel.incrementQuantityByOne()
                viewModel.addToCart()
        })
    }
    
    private var addToCart: some View {
        Button(action: {
            viewModel.incrementQuantityByOne()
            viewModel.addToCart()
        }) {
            HStack {
                if viewModel.product.isAddedToCart {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white)
                }
                Text(viewModel.product.isAddedToCart ? "Added to Cart" : "Add to Cart")
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(viewModel.product.isAddedToCart ? Color.green : Color.blue)
            .foregroundStyle(.white)
            .cornerRadius(12)
        }
        .disabled(viewModel.product.isAddedToCart)
        .padding(.top)
    }
    
}


