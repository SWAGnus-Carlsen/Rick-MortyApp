//
//  FavouritesTabCoordinator.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 17.05.24.
//

import UIKit

final class FavouritesTabCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    lazy var favoriteEpisodesController = {
        let vc = FavouritesController()
        return vc
    }()
    
    init() {
        rootViewController = UINavigationController()
    }
    
    func start() {
        rootViewController.setViewControllers([favoriteEpisodesController], animated: false)
    }
    
}
