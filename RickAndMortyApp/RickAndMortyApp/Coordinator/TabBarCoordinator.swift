//
//  TabBarCoordinator.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 17.05.24.
//

import UIKit

final class TabBarCoordinator: NSObject, Coordinator, UITabBarControllerDelegate {
    
    var rootViewController: UITabBarController
    var childCoordinators: [Coordinator] = []
    var dependency: IDependency
    
    init(dependency: IDependency) {
        self.rootViewController = UITabBarController()
        
        rootViewController.tabBar.isTranslucent = true
        rootViewController.tabBar.backgroundColor = .white
//        rootViewController.navigationController?.isNavigationBarHidden = true
        self.dependency = dependency
        
    }
    
    func start() {
        rootViewController.delegate = self
        
        let episodesTabCoordinator = EpisodesTabCoordinator(dependency: dependency)
        episodesTabCoordinator.start()
        childCoordinators.append(episodesTabCoordinator)
        let episodesController = episodesTabCoordinator.rootViewController
        episodesController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house") , selectedImage: UIImage(systemName: "house.fill"))
        
        let favoriteEpisodesCoordinator = FavouritesTabCoordinator(dependency: dependency)
        favoriteEpisodesCoordinator.start()
        childCoordinators.append(favoriteEpisodesCoordinator)
        let favoriteEpisodesController = favoriteEpisodesCoordinator.rootViewController
        favoriteEpisodesController.tabBarItem = UITabBarItem(title: "",  image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        self.rootViewController.viewControllers = [episodesController, favoriteEpisodesController]
        
    }
    
    
}

extension TabBarCoordinator {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard viewController == tabBarController.viewControllers![1],
              let navController = tabBarController.viewControllers![1] as? UINavigationController,
              let favouritesVC = navController.topViewController as? FavouritesController else { return }
        
        print("Favourites vc opened")
    }
}
