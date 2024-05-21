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
    
    init() {
        self.rootViewController = UITabBarController()
        rootViewController.tabBar.isTranslucent = true
        rootViewController.tabBar.backgroundColor = .white
        rootViewController.navigationController?.isNavigationBarHidden = true
    }
    
    func start() {
        let episodesTabCoordinator = EpisodesTabCoordinator()
        episodesTabCoordinator.start()
        childCoordinators.append(episodesTabCoordinator)
        let episodesController = episodesTabCoordinator.rootViewController
        episodesController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house") , selectedImage: UIImage(systemName: "house.fill"))
        
        let favoriteEpisodesCoordinator = FavoriteTabCoordinator()
        favoriteEpisodesCoordinator.start()
        childCoordinators.append(favoriteEpisodesCoordinator)
        let favoriteEpisodesController = favoriteEpisodesCoordinator.rootViewController
        favoriteEpisodesController.tabBarItem = UITabBarItem(title: "",  image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        self.rootViewController.viewControllers = [episodesController, favoriteEpisodesController]
        
    }
    
    
}
