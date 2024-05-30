//
//  EpisodesController.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 20.05.24.
//

import UIKit


final class EpisodesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    //MARK: UI Elements
    private lazy var rickAndMortyImage: UIImageView = makeRickAndMortyImage()
    private lazy var searchTF: UITextField = makeSearchTF()
    private var episodesCollection: UICollectionView?
    
    //MARK: Services
    private var networkService: INetworkService
    private var userdefaultsService: IUserDefaultsService
    
    //MARK: ViewModel
    private var viewModel: EpisodesViewModel
    
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
    private var favEpisodesIds: [Int] = []
    private var lastContentOffset: CGFloat = 0
    private var isScrollingDown = true
    
    //MARK: Closures
    private let didTapOnCharacter: (_ character: CharacterResponse) -> Void
    
    //MARK: Constructor
    init(dependency: IDependency, viewModel: EpisodesViewModel, didTapOnCharacter: @escaping (_ character: CharacterResponse) -> Void ) {
        self.networkService = dependency.networkService
        self.userdefaultsService = dependency.userDefaultsService
        self.viewModel = viewModel
        self.didTapOnCharacter = didTapOnCharacter
        super.init(nibName: nil, bundle: nil)
        favEpisodesIds = userdefaultsService.retrieve()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEpisodesCollection()
        setupConstraints()
        networkService.getAllEpisodes(forPage: 1) { [weak self] result in
            switch result {
            case .success(let response):
                let episodesArray: [Episode] = response.results
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
private extension EpisodesController {
    
    func setupUI() {
        view.backgroundColor = .white
    }
    
    func setupConstraints() {
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
               // print("\(indexPath.row) : \(character.name)")
                currentCharacter = character
                self?.shownCharacters.append(character)
                cell.setupCell(with: currentEpisode, and: currentCharacter, self?.networkService , isLiked: false, tag: indexPath.row, selector: #selector(self?.didEnterName) )
            case .failure(_):
                ()
            }
        }
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        didTapOnCharacter(shownCharacters[indexPath.row])
    }
}


extension EpisodesController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (lastContentOffset > scrollView.contentOffset.y) && (lastContentOffset < scrollView.contentSize.height - scrollView.frame.height) {
            // move up
            isScrollingDown = false
            
        } else if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 {
            // move down
         
            isScrollingDown = true
           
        }
        
        // update the new position acquired
        lastContentOffset = scrollView.contentOffset.y
    }
}

#Preview("") {
    let dependency = Dependency()
    return UINavigationController(rootViewController: EpisodesController(dependency: Dependency(), viewModel: EpisodesViewModel(), didTapOnCharacter: { character in
        
    } ))
    
}


