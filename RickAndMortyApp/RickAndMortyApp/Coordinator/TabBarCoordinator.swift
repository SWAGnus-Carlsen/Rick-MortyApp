//
//  TabBarCoordinator.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 17.05.24.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
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
        let episodesTabCoordinator = EpisodesTabCoordinator(dependency: dependency)
        episodesTabCoordinator.start()
        childCoordinators.append(episodesTabCoordinator)
        let episodesController = episodesTabCoordinator.rootViewController
        episodesController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house") , selectedImage: UIImage(systemName: "house.fill"))
        
        let favoriteEpisodesCoordinator = FavouritesTabCoordinator()
        favoriteEpisodesCoordinator.start()
        childCoordinators.append(favoriteEpisodesCoordinator)
        let favoriteEpisodesController = favoriteEpisodesCoordinator.rootViewController
        favoriteEpisodesController.tabBarItem = UITabBarItem(title: "",  image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        self.rootViewController.viewControllers = [episodesController, favoriteEpisodesController]
        
    }
    
    
}
