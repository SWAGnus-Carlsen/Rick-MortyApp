//
//  FavouritesViewModel.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 26.05.24.
//

import UIKit

final class FavouritesViewModel: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: Service
    private let networkService: INetworkService
    private let userDefaultsService: IUserDefaultsService
    
    //MARK: Closure
    private let didTapOnCharacterDetail: (_ character: CharacterResponse) -> Void
    
    //MARK: Propeties
    private var episodes: [Episode] = []{
        didSet {
           // DispatchQueue.main.async { [weak self] in
           //     self?.reloadCollectionData()
           //}
        }
    }
    private var characterURLs: [String] = []
    private var shownCharacters: [CharacterResponse] = []
    private var favEpisodesIDs: [Int] = []
    
    let dispatchGroup = DispatchGroup()
    
    
    //MARK: Constructor
    init(dependency: IDependency, didTapOnCharacterDetail: @escaping (_ character: CharacterResponse) -> Void) {
        self.networkService = dependency.networkService
        self.userDefaultsService = dependency.userDefaultsService
        self.didTapOnCharacterDetail = didTapOnCharacterDetail
    }
    
    //MARK: Public methods
    public func getCertainEpisodes() {
        networkService.getCertainEpisodes(withIDs: favEpisodesIDs) { [weak self] result in
            switch result {
            case .success(let episodesArray):
                
                self?.getAllCharacterURLs(from: episodesArray)
                self?.characterURLs.forEach {
                    self?.getShownCharacter(from: $0)
                }
                
                self?.dispatchGroup.notify(queue: .main) {
                    self?.episodes = episodesArray
                    self?.reloadCollectionData()
                }
                
                
                
            case .failure(let error):
                print(error.errorDescription)
            }
            
        }
    }
    
    public func getFavEpisodesIds() {
        favEpisodesIDs = userDefaultsService.retrieve()
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
    
    private func reloadCollectionData() {
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
    }
    
//    #warning("Я остановлися на этом ;//")
//    private func deleteRow(at indexPath: Int) {
//        NotificationCenter.default.post(name: NSNotification.Name("delete"), object: indexPath)
//    }
    
}

//MARK: - Collection setup
extension FavouritesViewModel {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EpisodesCVCell.identifier,
            for: indexPath
        ) as? EpisodesCVCell
        else {
            return UICollectionViewCell()
        }
        
        let currentEpisode = episodes[indexPath.row]
        let currentCharacter = shownCharacters[indexPath.row]
        
        cell.setupCell(with: currentEpisode, and: currentCharacter, networkService, isLiked: true, tag: indexPath.row, selector: #selector(likeTapped(_:)) )
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        didTapOnCharacterDetail(shownCharacters[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("\(#function) at \(indexPath.row)")
    }
    
    @objc
    func likeTapped(_ sender: UIButton) {
        episodes.remove(at: sender.tag)
    }
}
