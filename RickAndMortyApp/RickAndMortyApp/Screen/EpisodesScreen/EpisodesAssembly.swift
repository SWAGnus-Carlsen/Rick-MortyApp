//
//  EpisodesAssembly.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 20.05.24.
//

import Foundation

final class EpisodesAssembly {
    static func configure(dependency: IDependency, didTapOnCharacter: @escaping (_ character: CharacterResponse) -> Void) -> EpisodesController {
        let vm = EpisodesViewModel(dependency: dependency, didTapOnCharacter: didTapOnCharacter)
        let vc = EpisodesController(viewModel: vm)
        return vc
    }
}
