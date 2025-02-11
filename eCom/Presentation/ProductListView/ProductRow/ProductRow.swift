//
//  ProductRow.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 05/02/25.
//
import SwiftUI

struct ProductRow: View {
    @Bindable var viewModel: ProductRowViewModel
    
    init(viewModel: ProductRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                image
                VStack(alignment: .leading) {
                    title
                    price
                }
                Spacer()
                if viewModel.product.isAddedToCart {
                    quantity
                } else {
                    addToCart
                }
            }
            .padding()
            Divider()

        }
    }
    
    private var image: some View {
        HStack {
            AsyncCacheImage(url: URL(string: viewModel.product.thumbnail))
                .frame(width: 50, height: 50)
        }
    }
    
    private var title: some View {
        Text(viewModel.product.title)
            .font(.subheadline)
            .lineLimit(2)
    }
    
    private var price: some View {
        HStack {
            Text("$\(viewModel.product.price, specifier: "%.2f")")
                .font(.subheadline)
            
            Text("\(viewModel.product.discountPercentage, specifier: "%.0f")% OFF")
                .font(.caption)
                .foregroundStyle(.red)
                .padding(4)
                .background(Color.red.opacity(0.1))
                .cornerRadius(4)
        }
    }
    
    private var addToCart: some View {
        VStack {
            Spacer()
            Button {
                viewModel.incrementQuantityByOne()
            } label: {
                Text("Add to Cart")
                    .font(.system(size: 14.0))
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(Color.green)
                    .cornerRadius(6.0)
            }
        }
    }
    
    private var quantity: some View {
        VStack {
            Spacer()
            QuantityView(
                quantity: viewModel.product.quantity ?? 0,
                decrement: {
                    viewModel.decrementQuantityByOne()
                },
                increment: {
                    viewModel.incrementQuantityByOne()
            })
        }
    }
    
}

struct QuantityView: View {
    let quantity: Int
    let decrement: () -> Void
    let increment: () -> Void
    
    init(quantity: Int, decrement: @escaping () -> Void, increment: @escaping () -> Void) {
        self.quantity = quantity
        self.decrement = decrement
        self.increment = increment
    }
    
    var body: some View {
        HStack {
            Button("-") {
                self.decrement()
            }
            .padding(.horizontal, 8)
            Text("\(quantity)")
            Button("+") {
                self.increment()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
        }
        .padding(.horizontal,5)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
        .shadow(radius: 1.0)
    }
}
