//
//  AppDIContainer.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 11/02/25.
//
import Foundation

final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()
    
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)
        let apiNetworkService = DefaultNetworkService(config: config)
        return DefaultDataTransferService(networkService: apiNetworkService)
    }()
    
    lazy var cartManager: CartManager = {
        DefaultCartManager()
    }()
        
    func makeProductListDIContainer() -> ProductListDIContainer {
        let dependencies = ProductListDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            cartManager: cartManager
        )
        return ProductListDIContainer(dependencies: dependencies)
    }
    
    func makeCartListDIContainer() -> CartListDIContainer {
        let dependencies = CartListDIContainer.Dependencies(cartManager: cartManager)
        return CartListDIContainer(dependencies: dependencies)
    }
}

final class AppConfiguration {
    var apiKey = ""
    var apiBaseURL = "https://dummyjson.com"
}
