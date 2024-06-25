//
//  EpisodesViewModel.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 20.05.24.
//

import UIKit
import Combine
import UIScrollView_InfiniteScroll

final class EpisodesViewModel  {
    //MARK: Services
    var networkService: INetworkService
    private var userdefaultsService: IUserDefaultsService
    
    //MARK: Public propeties
    var episodes: [Episode] = []
    var characterURLs: [String] = []
    var shownCharacters: [CharacterResponse] = []
    var favEpisodesIds: [Int] = []
    let updateSnapshotRequest = PassthroughSubject<Void, Never>()
    let stopIndicatorRequest = PassthroughSubject<Void, Never>()
    let serieIdentifier = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: Private properties
    private var nextPageToLoad: Int = 1
    private let dispatchGroup = DispatchGroup()
    
    
    //MARK: Closures
    let didTapOnCharacter: (_ character: CharacterResponse) -> Void
    
    //MARK: Constructor
    init(dependency: IDependency, didTapOnCharacter: @escaping (_ character: CharacterResponse) -> Void ) {
        self.networkService = dependency.networkService
        self.userdefaultsService = dependency.userDefaultsService
        self.didTapOnCharacter = didTapOnCharacter
        setupSubscriptions()
        getFavEpispdesIDs()
    }
    
    //MARK: Public methods
    public func getAllEpisodes(for collection: UICollectionView) {
        getAndAddNewEpisodes(for: collection)
        
        collection.infiniteScrollDirection = .vertical
        collection.infiniteScrollIndicatorStyle = .large
    
        collection.addInfiniteScroll { [weak self] collection in
            self?.getAndAddNewEpisodes(for: collection)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                collection.finishInfiniteScroll()
            }
        }
        
    }
    
    public func getFavEpispdesIDs() {
        favEpisodesIds = userdefaultsService.retrieve()
    }
    
    private func getFilteredEpisodes(for serie: String) {
        if serie == "" {
            nextPageToLoad = 2
        } else {
            nextPageToLoad = Int.max
        }
        networkService.getFilteredEpisodes(for: serie) { [weak self] result in
            switch result {
            case .success(let response):
                let episodesArray: [Episode] = response.results
                self?.characterURLs = []
                self?.shownCharacters = []
                self?.episodes = []

                self?.getAllCharacterURLs(from: episodesArray)
                self?.characterURLs.forEach {
                    self?.getShownCharacter(from: $0)
                }
                self?.dispatchGroup.notify(queue: .main) {
                    self?.episodes.append(contentsOf: episodesArray)
                    self?.updateSnapshotRequest.send()
                    self?.stopIndicatorRequest.send()
                }
                
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    
    //MARK: Private methods
    private func setupSubscriptions() {
        serieIdentifier.sink { [unowned self] serie in
            getFilteredEpisodes(for: serie)
        }.store(in: &subscriptions)
    }
    
    private func getAndAddNewEpisodes(for collection: UICollectionView) {
        networkService.getAllEpisodes(forPage: nextPageToLoad) { [weak self] result in
            switch result {
            case .success(let response):
                let episodesArray: [Episode] = response.results
                self?.getAllCharacterURLs(from: episodesArray)
                self?.characterURLs.forEach {
                    self?.getShownCharacter(from: $0)
                }
                self?.dispatchGroup.notify(queue: .main) {
                    self?.nextPageToLoad += 1
                    self?.episodes.append(contentsOf: episodesArray)
                    self?.updateSnapshotRequest.send()
                    self?.stopIndicatorRequest.send()
                    collection.finishInfiniteScroll()
                }
                
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
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
                self?.shownCharacters.append(character)
                self?.dispatchGroup.leave()
            case .failure(_): ()
            }
        }
    }
    
}
