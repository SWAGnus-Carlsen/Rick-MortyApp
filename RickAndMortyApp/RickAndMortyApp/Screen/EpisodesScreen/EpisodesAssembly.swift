//
//  EpisodesAssembly.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 20.05.24.
//

import Foundation

final class EpisodesAssembly {
    static func configure(dependency: IDependency) -> EpisodesController {
        let vm = EpisodesViewModel()
        let vc = EpisodesController(dependency: dependency, viewModel: vm)
        return vc
    }
}
