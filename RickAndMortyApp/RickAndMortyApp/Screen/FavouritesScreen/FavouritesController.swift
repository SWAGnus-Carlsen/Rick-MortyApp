//
//  FavouritesController.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 26.05.24.
//

import UIKit

final class FavouritesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: UI Elements
    private var episodesCollection: UICollectionView?
    
    //MARK: Network service
    private var networkService = NetworkService()
    
    //MARK: Propeties
    private var episodes: [Episode] = []{
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.episodesCollection?.reloadData()
            }
        }
    }
    private var characterURLs: [String] = []
    private var shownCharacters: [CharacterResponse] = []
    
    //MARK: Closures
    //private let didTapOnCharacter: (_ character: CharacterResponse) -> Void
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEpisodesCollection()
        setupConstraints()
        
        networkService.getCertainEpisodes(withIDs: [1, 20, 25]){ [weak self] result in
            switch result {
            case .success(let episodesArray):
                self?.getAllCharacterURLs(from: episodesArray)
                self?.episodes = episodesArray
            case .failure(let error):
                print(error.errorDescription)
            }
        }
        
        
    }

    //MARK: Methods
    private func getAllCharacterURLs(from episodesArray: [Episode]) {
        for episode in episodesArray {
            let randomCharacterURL = episode.characters.randomElement() ?? ""
            characterURLs.append(randomCharacterURL)
        }
    }
}

//MARK: - UI
private extension FavouritesController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        //self.title = "Favourite episodes"
    }
    
    func setupConstraints() {
        guard let episodesCollection else { return }
        view.addSubview(episodesCollection)
        
        NSLayoutConstraint.activate([
            episodesCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            episodesCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            episodesCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            episodesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Collection setup
extension FavouritesController {
    
    private func setupEpisodesCollection() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = view.frame.size.width / 20
        flowLayout.itemSize = CGSize(width: 311, height: 357)
        episodesCollection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        guard let episodesCollection else { return }
        episodesCollection.showsVerticalScrollIndicator = true
        
        episodesCollection.register(EpisodesCVCell.self,
                                forCellWithReuseIdentifier: EpisodesCVCell.identifier)
        episodesCollection.delegate = self
        episodesCollection.dataSource = self
        episodesCollection.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
        var currentCharacter: CharacterResponse?
        
        
        networkService.getCharacter(with: characterURLs[indexPath.row] ) { [weak self] result in
            switch result {
            case .success(let character):
                print("\(indexPath.row) : \(character.name)")
                currentCharacter = character
                self?.shownCharacters.append(character)
                cell.setupCell(with: currentEpisode, and: currentCharacter, self?.networkService)
            case .failure(_):
                ()
            }
        }
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        //didTapOnCharacter(shownCharacters[indexPath.row])
        let vc = DetailController(character: shownCharacters[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
