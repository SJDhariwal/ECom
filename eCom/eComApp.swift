//
//  eComApp.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 31/01/25.
//

import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate {
    let appDIContainer = AppDIContainer()
    var appFlowCoardinator: AppFlowCoardinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        
        window?.rootViewController = navigationController
        appFlowCoardinator = AppFlowCoardinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        appFlowCoardinator?.start()
        window?.makeKeyAndVisible()
    }
}

