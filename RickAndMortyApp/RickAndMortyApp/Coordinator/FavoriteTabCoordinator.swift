//
//  FavoriteTabCoordinator.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 17.05.24.
//

import UIKit

final class FavoriteTabCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    lazy var favoriteEpisodesController = {
        let vc = HomeController()
        return vc
    }()
    
    init() {
        rootViewController = UINavigationController()
    }
    
    func start() {
        rootViewController.setViewControllers([favoriteEpisodesController], animated: false)
    }
    
}
