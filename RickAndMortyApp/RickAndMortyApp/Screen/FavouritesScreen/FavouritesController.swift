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
        setupUI()
        setupEpisodesCollection()
        viewModel.getFavEpisodesIds()
        viewModel.getCertainEpisodes()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    //MARK: Action
    @objc
    private func reloadEpisodesCollection(notification: NSNotification) {
      self.episodesCollection?.reloadData()
    }
    
    @objc
    private func deleteItem(notification: NSNotification) {
        guard let index = notification.object as? Int else {
            print("Cannot convert to int")
            return
        }
        self.episodesCollection?.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    //MARK: Methods
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadEpisodesCollection(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadEpisodesCollection(notification:)), name: NSNotification.Name(rawValue: "delete"), object: nil)
        
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
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
