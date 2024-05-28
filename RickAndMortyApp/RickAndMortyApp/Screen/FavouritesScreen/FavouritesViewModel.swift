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
    
    //MARK: Closure
    private let didTapOnCharacterDetail: (_ character: CharacterResponse) -> Void
    
    //MARK: Propeties
    private var episodes: [Episode] = []{
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.reloadCollectionData()
            }
        }
    }
    private var characterURLs: [String] = []
    private var shownCharacters: [CharacterResponse] = []
    private var ids: [Int] = []
    
    
    //MARK: Constructor
    init(dependency: IDependency, didTapOnCharacterDetail: @escaping (_ character: CharacterResponse) -> Void) {
        self.networkService = dependency.networkService
        self.didTapOnCharacterDetail = didTapOnCharacterDetail
    }
    
    //MARK: Public methods
    public func getCertainEpisodes(withIDs ids: [Int]) {
        networkService.getCertainEpisodes(withIDs: [1,2,3,12,23,24]) { [weak self] result in
            switch result {
            case .success(let episodesArray):
                self?.getAllCharacterURLs(from: episodesArray)
                self?.episodes = episodesArray
            case .failure(let error):
                print(error.errorDescription)
            }
            
        }
    }
    
    

    //MARK: Private methods
    private func getAllCharacterURLs(from episodesArray: [Episode]) {
        for episode in episodesArray {
            let randomCharacterURL = episode.characters.randomElement() ?? ""
            characterURLs.append(randomCharacterURL)
        }
    }
    
    private func reloadCollectionData() {
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
    }
    
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
        let currentCharacterUrl = characterURLs[indexPath.row]
        
        networkService.getCharacter(with: currentCharacterUrl ) { [weak self] result in
            switch result {
            case .success(let character):
                print("\(indexPath.row) : \(character.name)")
                self?.shownCharacters.append(character)
                cell.setupCell(with: currentEpisode, and: character, self?.networkService)
            case .failure(_):
                ()
            }
        }
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        didTapOnCharacterDetail(shownCharacters[indexPath.row])
    }
}
