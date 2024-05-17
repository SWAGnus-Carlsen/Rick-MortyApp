//
//  ApplicationCoordinator.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 17.05.24.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
    
    private let window: UIWindow
    private var rootViewController = UIViewController()
    private var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        self.window.rootViewController = SplashController(showMainFlow: startTabBarCoordinator)
        
    }
    
    private func startTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator()
        childCoordinators = [tabBarCoordinator]
        tabBarCoordinator.start()
        window.rootViewController = tabBarCoordinator.rootViewController
    }
    
}
