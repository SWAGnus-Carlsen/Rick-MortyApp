//
//  DetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 24.05.24.
//

import UIKit

final class DetailViewModel {
    //MARK: Service
    let networkService: INetworkService
    
    //MARK: Properties
    var character: CharacterResponse
    
    //MARK: Constructor
    init(character: CharacterResponse, dependency: IDependency) {
        self.character = character
        self.networkService = dependency.networkService
    }
    
    //MARK: Methods
    func setImage(for imageView: UIImageView) {
        networkService.getImage(with: character.id, for: imageView)
    }
}
