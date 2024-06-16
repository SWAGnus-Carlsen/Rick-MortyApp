//
//  FavouritesViewModel.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 26.05.24.
//

import UIKit
import Combine


final class FavouritesViewModel: NSObject, UICollectionViewDelegate {
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Episode>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Episode>
    
    //MARK: Data Source
    var dataSource: DataSource?
    
    //MARK: Service
    private let networkService: INetworkService
    private let userDefaultsService: IUserDefaultsService
    
    //MARK: Closure
    private let didTapOnCharacterDetail: (_ character: CharacterResponse) -> Void
    
    //MARK: Private propeties
    private var episodes: [Episode] = []
    
    private var characterURLs: [String] = []
    private var shownCharacters: [CharacterResponse] = []
    private var favEpisodesIDs: [Int] = []
    
    private let dispatchGroup = DispatchGroup()
    
    private var shouldRequest = true
    
    //MARK: Public properties
    let updateSnapshotRequest = PassthroughSubject<Void, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: Constructor
    init(dependency: IDependency, didTapOnCharacterDetail: @escaping (_ character: CharacterResponse) -> Void) {
        self.networkService = dependency.networkService
        self.userDefaultsService = dependency.userDefaultsService
        self.didTapOnCharacterDetail = didTapOnCharacterDetail
        super.init()
//        getFavEpisodesIds()
//        getCertainEpisodes()
    }
    
    //MARK: Public methods
    public func getFavouriteEpisodes() {
        getFavEpisodesIds()
        //guard shouldRequest else { return }
        shownCharacters = []
        characterURLs = []
        if favEpisodesIDs.count >= 2 {
           getCertainEpisodes()
        } else if favEpisodesIDs.count == 1  {
           getOneEpisode()
        } else if favEpisodesIDs.count == 0 {
            episodes = []
            updateSnapshotRequest.send()
        }
        
        
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
                self?.shownCharacters.append(character)
                self?.dispatchGroup.leave()
            case .failure(_):
                ()
            }
        }
    }
    
    private func getFavEpisodesIds() {
        let retrievedIDs = userDefaultsService.retrieve()
        print("retrieved: \(retrievedIDs)")
        print("Old: \(favEpisodesIDs)")
        shouldRequest = Set(favEpisodesIDs) != Set(retrievedIDs)
        if shouldRequest {
            favEpisodesIDs = retrievedIDs
        }
    }
    
    private func getCertainEpisodes() {
        networkService.getCertainEpisodes(withIDs: favEpisodesIDs) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let episodesArray):
                
                self.getAllCharacterURLs(from: episodesArray)
                self.characterURLs.forEach {
                    self.getShownCharacter(from: $0)
                }
                
                self.dispatchGroup.notify(queue: .main) {
                    self.episodes = episodesArray
                    self.updateSnapshotRequest.send()
                }
            case .failure(let error):
                print(error.errorDescription)
            }
            
        }
    }
    
    private func getOneEpisode() {
        networkService.getOneEpisode(withID: favEpisodesIDs.first!) { [weak self] result in
            switch result {
            case .success(let episode):
                let randomCharacterURL = episode.characters.randomElement() ?? ""
                self?.characterURLs = [randomCharacterURL]
                
                self?.getShownCharacter(from: randomCharacterURL)
                
                self?.dispatchGroup.notify(queue: .main) {
                    
                    self?.episodes = [episode]
                    self?.updateSnapshotRequest.send()
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
}

//MARK: - Collection setup
extension FavouritesViewModel {
    
    func setupDataSource(collection: UICollectionView) {
        dataSource = DataSource(collectionView: collection, cellProvider: { [weak self] collectionView, indexPath, episode in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EpisodesCVCell.identifier,
                for: indexPath
            ) as? EpisodesCVCell
            else {
                return UICollectionViewCell()
            }
            
            let currentCharacter = self?.shownCharacters[indexPath.row]
            let buttonAction = self?.likeTapped(_:) ?? { _ in  print("Error while passing like button action")}
            
            cell.setupCell(with: episode, and: currentCharacter, self?.networkService, isLiked: true, tag: indexPath.row, buttonAction: buttonAction)
     
            return cell
        })
    }
    
    func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(episodes)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        didTapOnCharacterDetail(shownCharacters[indexPath.row])
    }
    
    
    //MARK: Method to pass
    func likeTapped(_ sender: UIButton) {
        episodes.remove(at: sender.tag)
        updateSnapshotRequest.send()
    }
    
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        episodes.count
    //    }
        
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        guard let cell = collectionView.dequeueReusableCell(
    //            withReuseIdentifier: EpisodesCVCell.identifier,
    //            for: indexPath
    //        ) as? EpisodesCVCell
    //        else {
    //            return UICollectionViewCell()
    //        }
    //
    //        let currentEpisode = episodes[indexPath.row]
    //        let currentCharacter = shownCharacters[indexPath.row]
    //
    //        cell.setupCell(with: currentEpisode, and: currentCharacter, networkService, isLiked: true, tag: indexPath.row, buttonAction: likeTapped(_:))
    //
    //        return cell
    //    }
}
