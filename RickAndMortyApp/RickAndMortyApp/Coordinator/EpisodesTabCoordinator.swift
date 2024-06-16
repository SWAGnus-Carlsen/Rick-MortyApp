//
//  EpisodesTabCoordinator.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 17.05.24.
//

import UIKit

final class EpisodesTabCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    var dependency: IDependency
    
    lazy var episodesController = {
        let vc = EpisodesAssembly.configure(dependency: dependency, didTapOnCharacter: didTapOnCharacter(character:))
        return vc
    }()
    
    init(dependency: IDependency) {
        rootViewController = UINavigationController()
        self.dependency = dependency
    }
    
    func start() {
        rootViewController.setViewControllers([episodesController], animated: false)
    }
    
    //MARK: Closures to pass
    private func didTapOnCharacter(character: CharacterResponse) {
        let vc = DetailAssembly.configure(character: character, dependency: dependency)
        rootViewController.show(vc, sender: self)
    }
    
    
}
