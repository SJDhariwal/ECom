//
//  CartBadgeView.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 05/02/25.
//

import SwiftUI

struct CartBadgeView: View {
    @StateObject var viewModel: CartBadgeViewModel
    private let cartTapAction: () -> Void
    
    init(viewModel: CartBadgeViewModel, cartTapAction: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.cartTapAction = cartTapAction
    }

    var body: some View {
        ZStack {
            Image(systemName: "cart")
            if viewModel.cartCount > 0 {
                Text("\(viewModel.cartCount)")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: 10, y: -10)
            }
        }
        .onTapGesture {
            self.cartTapAction()
        }
    }
}
