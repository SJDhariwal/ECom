//
//  AppFlowCoardinator.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 02/02/25.
//

import UIKit
import SwiftUI

final class AppFlowCoardinator {
    private var navigationController: UINavigationController
    private var appDIContainer: AppDIContainer

    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        startProductListFlow()
    }
    
    private func startProductListFlow() {
        let productListDIContainer = appDIContainer.makeProductListDIContainer()
        let productListFlowCoardinator = productListDIContainer.makeProductListFlowCoardinator(
            navigatioinController: navigationController,
            delegate: self
        )
        productListFlowCoardinator.start()
    }
    
    private func startCartListFlow() {
        let cartListDIContainer = appDIContainer.makeCartListDIContainer()
        let cartListFlowCoardinator = cartListDIContainer.makeCartListFlowCoardinator(
            navigatioinController: navigationController,
            delegate: self
        )
        cartListFlowCoardinator.start()
    }
}

extension AppFlowCoardinator: ProductListFlowCoardinatorDelegate {
    func didRequestCartFlow(from coardinator: ProductListFlowCoardinator) {
        startCartListFlow()
    }
}

extension AppFlowCoardinator: CartFlowCoardinatorDelegate {
    func cartFlowFinished(from coardinator: CartListFlowCoardinator) {
        
    }
}

