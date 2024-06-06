//
//  EpisodesViewModel.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 20.05.24.
//

import UIKit
import Combine

final class EpisodesViewModel  {
    
    //MARK: Services
    var networkService: INetworkService
    private var userdefaultsService: IUserDefaultsService
    
    //MARK: Public propeties
    var episodes: [Episode] = []
    var characterURLs: [String] = []
    var shownCharacters: [CharacterResponse] = []
    var favEpisodesIds: [Int] = []
    let reloadCollectionRequest = PassthroughSubject<Void, Never>()
    let stopIndicatorRequest = PassthroughSubject<Void, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: Private properties
    
    private let dispatchGroup = DispatchGroup()
    
    
    //MARK: Closures
    let didTapOnCharacter: (_ character: CharacterResponse) -> Void
    
    //MARK: Constructor
    init(dependency: IDependency, didTapOnCharacter: @escaping (_ character: CharacterResponse) -> Void ) {
        self.networkService = dependency.networkService
        self.userdefaultsService = dependency.userDefaultsService
        self.didTapOnCharacter = didTapOnCharacter
        getFavEpispdesIDs()
    }
    
    //MARK: Public methods
    public func getAllEpisodes() {
        networkService.getAllEpisodes(forPage: 1) { [weak self] result in
            switch result {
            case .success(let response):
                let episodesArray: [Episode] = response.results
                self?.getAllCharacterURLs(from: episodesArray)
                self?.characterURLs.forEach {
                    self?.getShownCharacter(from: $0)
                }
                self?.dispatchGroup.notify(queue: .main) {
                    self?.episodes = episodesArray
                    self?.reloadCollectionRequest.send()
                    self?.stopIndicatorRequest.send()
                }
                
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    public func getFavEpispdesIDs() {
        favEpisodesIds = userdefaultsService.retrieve()
    }
    
    //MARK: Private methods
    private func getAllCharacterURLs(from episodesArray: [Episode]) {
        for episode in episodesArray {
            let randomCharacterURL = episode.characters.randomElement() ?? ""
            characterURLs.append(randomCharacterURL)
        }
    }
    
    private func getShownCharacter(from urlString: String) {
        dispatchGroup.enter()
        networkService.getCharacter(with: urlString ) { [weak self] result in
            switch result {
            case .success(let character):
                print("Appended : \(character.name)")
                self?.shownCharacters.append(character)
                self?.dispatchGroup.leave()
            case .failure(_):
                ()
            }
        }
    }
    
}
