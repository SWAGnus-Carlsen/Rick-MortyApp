//
//  FavouritesController.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 26.05.24.
//

import UIKit

final class FavouritesController: UIViewController {

    //MARK: UI Elements
    private var episodesCollection: UICollectionView?
    
    //MARK: ViewModel
    private let viewModel: FavouritesViewModel
    
    //MARK: Constructor
    init(viewModel: FavouritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        setupUI()
        setupEpisodesCollection()
        viewModel.getCertainEpisodes(withIDs: [])
        setupConstraints()
    }
    
    //MARK: Action
    @objc
    private func loadList(notification: NSNotification) {
      self.episodesCollection?.reloadData()
    }
}

//MARK: - UI
private extension FavouritesController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Favourite episodes"
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
        episodesCollection.delegate = viewModel
        episodesCollection.dataSource = viewModel
        episodesCollection.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
