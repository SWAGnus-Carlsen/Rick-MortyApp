//
//  FavouritesAssembly.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 26.05.24.
//

import UIKit

final class FavouritesAssembly {
    static func configure(didTapOnCharacterDetail: @escaping (_ character: CharacterResponse) -> Void, dependency: IDependency) -> FavouritesController {
        let vm = FavouritesViewModel(dependency: dependency, didTapOnCharacterDetail: didTapOnCharacterDetail)
        let vc = FavouritesController(viewModel: vm)
        return vc
    }
}
