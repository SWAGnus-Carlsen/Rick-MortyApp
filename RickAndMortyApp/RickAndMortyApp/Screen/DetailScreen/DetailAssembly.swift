//
//  DetailAssembly.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 24.05.24.
//

import Foundation

final class DetailAssembly {
    static func configure(character: CharacterResponse) -> DetailController {
        let vm = DetailViewModel()
        let vc  = DetailController(character: character)
        return vc
    }
}
