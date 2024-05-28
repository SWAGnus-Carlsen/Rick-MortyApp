//
//  FavouritesTabCoordinator.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 17.05.24.
//

import UIKit

final class FavouritesTabCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    let dependency: IDependency
    
    
    lazy var favoriteEpisodesController = {
        let vc = FavouritesAssembly.configure(didTapOnCharacterDetail: didTapOnCharacter, dependency: dependency)
        return vc
    }()
    
    init(dependency: IDependency) {
        self.dependency = dependency
        rootViewController = UINavigationController()
    }
    
    func start() {
        rootViewController.setViewControllers([favoriteEpisodesController], animated: false)
    }
    
    //MARK: Closures to pass
    private func didTapOnCharacter(_ character: CharacterResponse) {
        let vc = DetailAssembly.configure(character: character)
        rootViewController.show(vc, sender: self)
    }
    
}
