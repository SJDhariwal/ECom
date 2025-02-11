//
//  ViewDidLoadModifier.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 06/02/25.
//
import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    @State private var isLoad = false
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if isLoad == false {
                isLoad = true
                action()
            }
        }
    }
}

extension View {
    func onLoad(perform action: @escaping () -> Void) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
}
