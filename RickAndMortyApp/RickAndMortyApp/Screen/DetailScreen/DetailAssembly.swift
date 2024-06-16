//
//  DetailAssembly.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 24.05.24.
//

import Foundation

final class DetailAssembly {
    static func configure(character: CharacterResponse, dependency: IDependency) -> DetailController {
        let vm = DetailViewModel(character: character, dependency: dependency)
        let vc  = DetailController(viewModel: vm)
        return vc
    }
}
