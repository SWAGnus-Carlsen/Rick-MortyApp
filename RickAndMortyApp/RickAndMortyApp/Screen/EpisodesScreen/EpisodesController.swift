//
//  EpisodesController.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 20.05.24.
//

import UIKit



final class EpisodesController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {
    enum EpisodesSection {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<EpisodesSection, Episode>
    typealias Snapshot = NSDiffableDataSourceSnapshot<EpisodesSection, Episode>
    
    //MARK: UI Elements
    private lazy var activityIndicator: UIActivityIndicatorView = makeActivityIndicator()
    private lazy var rickAndMortyImage: UIImageView = makeRickAndMortyImage()
    private lazy var searchTF: UITextField = makeSearchTF()
    private var episodesCollection: UICollectionView?
    
    //MARK: DataSource
    var dataSource: DataSource?
    
    
    //MARK: ViewModel
    private var viewModel: EpisodesViewModel
    
    //MARK: Constructor
    init(viewModel: EpisodesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscriptions()
        setupUI()
        setupEpisodesCollection()
        setupConstraints()
        setupCollectionDataSource()
        updateData()
        
        //get episodes
        viewModel.getAllEpisodes(for: episodesCollection!)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavEpispdesIDs()
        //Snapshot doesn't change but like button can that is why i'm using reload data here
        episodesCollection?.reloadData()
    }
    
    //MARK: Private methods
    private func setupSubscriptions() {
        viewModel.updateSnapshotRequest.sink { [unowned self] _ in
            updateData()
        }.store(in: &viewModel.subscriptions)
        
        viewModel.stopIndicatorRequest.sink { [unowned self] _ in
            activityIndicator.stopAnimating()
        }.store(in: &viewModel.subscriptions)
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
        episodesCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            episodesCollection.topAnchor.constraint(equalTo: searchTF.bottomAnchor, constant: 16),
            episodesCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            episodesCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            episodesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
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
    
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        ai.style = .large
        ai.startAnimating()
        return ai
    }
}


//MARK: - Action
private extension EpisodesController {
    @objc
    func didEnterName() {
        viewModel.serieIdentifier.send(searchTF.text ?? "")
    }
}

//MARK: - Collection Diffable DataSource
private extension EpisodesController {
    
    
    
    func setupEpisodesCollection() {
        
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
        episodesCollection.dataSource = dataSource
        
    }
    
    func setupCollectionDataSource() {
        dataSource = DataSource(collectionView: episodesCollection!, cellProvider: { [weak self] collectionView, indexPath, episode in
            guard let self else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EpisodesCVCell.identifier,
                for: indexPath
            ) as? EpisodesCVCell
            else {
                return UICollectionViewCell()
            }
            
            let currentCharacter = viewModel.shownCharacters[indexPath.row]
            let shouldBeLiked = viewModel.favEpisodesIds.contains(episode.id)
            
            cell.setupCell(
                with: episode,
                and: currentCharacter,
                viewModel.networkService,
                isLiked: shouldBeLiked ,
                tag: indexPath.row, buttonAction: { _ in }
            )
            return cell
        })
    }
    
    func updateData() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.episodes)
        dataSource?.apply(snapshot)
    }
    

}

//MARK: - Collection Delegate
extension EpisodesController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        viewModel.didTapOnCharacter(viewModel.shownCharacters[indexPath.row])
    }
    // Some cool animations
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeRotation(10, 1, 1, 0)
        UIView.animate(withDuration: 1.0, animations: {
        cell.alpha = 1

            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        })
    }
}


//extension EpisodesController {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        if (lastContentOffset > scrollView.contentOffset.y) && (lastContentOffset < scrollView.contentSize.height - scrollView.frame.height) {
//            // move up
//            isScrollingDown = false
//            
//        } else if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 {
//            // move down
//         
//            isScrollingDown = true
//           
//        }
//        
//        // update the new position acquired
//        lastContentOffset = scrollView.contentOffset.y
//    }
//}

//#Preview("") {
//    let dependency = Dependency()
//    let vm = EpisodesViewModel()
////    let character = CharacterResponse(id: 1, name: "HH", status: "kkkk", species: "kk", type: "kkkk", gender: "kkkk", origin: Location(name: "ll", url: ""), location: Location(name: "ll", url: ""), image: "", episode: [], url: "", created: "")
//    lazy var navController = UINavigationController(rootViewController: EpisodesController(dependency: dependency, viewModel: vm, didTapOnCharacter: didTapOnCharacter(character:) ))
//    func didTapOnCharacter(character: CharacterResponse) {
//        let vc = DetailAssembly.configure(character: character)
//        navController.pushViewController(vc, animated: true)
//    }
//    return navController
//    
//}


