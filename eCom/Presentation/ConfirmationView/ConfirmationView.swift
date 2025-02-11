//
//  ConfirmationView.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 31/01/25.
//

import SwiftUI

struct ConfirmationView: View {
    @State private var viewModel: ConfirmationViewModel
    
    init(viewModel: ConfirmationViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundStyle(.green)
                .padding(.top, 40)
            
            Text("Thank you for Your Order!")
                .font(.title)
                .fontWeight(.bold)
            
            Button {
                viewModel.cartFlowFinished()
            } label: {
                Text("Continue Shopping")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
            }

        }
        .navigationBarBackButtonHidden()
        .padding()
    }
}
