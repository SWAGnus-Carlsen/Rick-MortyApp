//
//  EpisodesTabCoordinator.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 17.05.24.
//

import UIKit

final class EpisodesTabCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    lazy var episodesController = {
        let vc = EpisodesController()
        return vc
    }()
    
    init() {
        rootViewController = UINavigationController()
    }
    
    func start() {
        rootViewController.setViewControllers([episodesController], animated: false)
    }
    
    
    
}
