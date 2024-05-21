//
//  EpisodesController.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 20.05.24.
//

import UIKit

struct Episode {
    let image: UIImage
    let name: String
    let id: String
    let description: String
}

final class EpisodesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: UI Elements
    private lazy var rickAndMortyImage: UIImageView = makeRickAndMortyImage()
    private lazy var searchTF: UITextField = makeSearchTF()
    private var episodesCollection: UICollectionView?
    
    //MARK: Propeties
    private var episodes: [Episode] = [
        Episode(image: .episodePlaceholder, name: "Rick Sanchez", id: "S01E01", description: "Pilot" ),
        Episode(image: .episodePlaceholder, name: "Rick Sanchez", id: "S01E01", description: "Pilot" ),
        Episode(image: .episodePlaceholder, name: "Rick Sanchez", id: "S01E01", description: "Pilot" )
    ]
    private var results: [Result] = []
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEpisodesCollection()
        setupConstraints()
        
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://rickandmortyapi.com/api/episode?page=1")!)) { [weak self] data,_,error in
            if error != nil {
                print("Episodes fetch error")
            }
            
            guard let data else { return }
            do {
                print(data.prettyPrintedJSONString)
                let response = try JSONDecoder().decode(EpisodesResponse.self, from: data)
                self?.results = response.results
                
            } catch {
                print("Error occured while decoding episodes")
            }
            
        }.resume()
    }
}

//MARK: - UI
private extension EpisodesController {
    
    func setupUI() {
        view.backgroundColor = .white
    }
    
    func  setupConstraints() {
        NSLayoutConstraint.activate([
            rickAndMortyImage.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            rickAndMortyImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            rickAndMortyImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            searchTF.topAnchor.constraint(equalToSystemSpacingBelow: rickAndMortyImage.safeAreaLayoutGuide.bottomAnchor, multiplier: 6),
            searchTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            searchTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            searchTF.heightAnchor.constraint(equalToConstant: 56)
        ])
        guard let episodesCollection else { return }
        view.addSubview(episodesCollection)
        
        NSLayoutConstraint.activate([
            episodesCollection.topAnchor.constraint(equalTo: searchTF.bottomAnchor, constant: 16),
            episodesCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            episodesCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            episodesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func makeRickAndMortyImage() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = .rickAndMortySign
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        view.addSubview(iv)
        return iv
    }
    
    func makeSearchTF() -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.leftImage(.magnifyingGlass, imageWidth: 13, padding: 18)
    
        tf.layer.cornerRadius = 10
        tf.layer.masksToBounds = true
        tf.font = .systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Name or episode (ex.S01E01)...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        view.addSubview(tf)
        tf.addTarget(self, action: #selector(didEnterName), for: .editingChanged)
        return tf
    }
}


//MARK: - Action
private extension EpisodesController {
    @objc
    func didEnterName() {
        
    }
}

//MARK: - Collection setup
extension EpisodesController {
    
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
            for: indexPath) as? EpisodesCVCell
        else {
            return UICollectionViewCell()
        }
        
        cell.setupCell(with: episodes[indexPath.row])
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

#Preview("") {
    EpisodesController()
}
