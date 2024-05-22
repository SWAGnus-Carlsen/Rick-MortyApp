//
//  CharacterResponse.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 23.05.24.
//

import Foundation

// MARK: - CharacterResponse
struct CharacterResponse: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct Location: Decodable {
    let name: String
    let url: String
}
