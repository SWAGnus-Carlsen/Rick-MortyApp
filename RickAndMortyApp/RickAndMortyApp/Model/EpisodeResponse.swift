//
//  EpisodeResponse.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 21.05.24.
//

import Foundation

// MARK: - EpisodesResponse
struct EpisodesResponse: Decodable {
    let info: Info
    let results: [Episode]
}

// MARK: - Info
struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Result
struct Episode: Decodable, Hashable {
    let id: Int
    let name: String
    let episode: String
    let characters: [String]
    let url: String
    
    let uuid = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
