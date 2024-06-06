//
//  EpisodesCVCell.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 21.05.24.
//

import UIKit
import Combine

final class EpisodesCVCell: UICollectionViewCell {
    
    //MARK: ID
    static let identifier = String(describing: EpisodesCVCell.self)
    
    //MARK: Properties
    private var isLiked: Bool = false
    private var currentEpisode: Episode?
    
    private var didTapOnLike: (_ sender: UIButton) -> Void = {sender in }
    
    //MARK: UI
    lazy var episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 20, weight: .semibold)
        l.textColor = .black
        l.textAlignment = .left
        l.text = ""
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var watchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = .tvSign
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16)
        l.textColor = .black
        l.textAlignment = .left
        l.text = ""
        l.numberOfLines = 0
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    private lazy var likeButton: UIButton = {
        let b = UIButton()
        b.setImage(.like, for: .normal)
        b.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return b
    }()
    
    //MARK: Override methods
    override init(frame: CGRect) {
        super.init (frame: frame)
        contentView.backgroundColor = .gray.withAlphaComponent(0.5)
        //contentView.layer.borderColor = UIColor.defaultGray.withAlphaComponent(0.3).cgColor
        contentView.addSubview(episodeImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(watchImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likeButton)
        
        layoutUI()
        
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = contentView.frame.height / 16
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        episodeImageView.image = nil
        likeButton.setImage(nil, for: .normal)
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
    
    //MARK: Setup methods
    func setupCell(with episode: Episode, and character: CharacterResponse?, _ networkService: INetworkService?, isLiked: Bool, tag: Int, buttonAction: @escaping (_ sender: UIButton) -> Void) {
        
        currentEpisode = episode

        networkService?.getImage(with: character?.id ?? 0, for: episodeImageView)
        DispatchQueue.main.async {
            self.isLiked = isLiked
            self.nameLabel.text = character?.name
            self.descriptionLabel.text = "\(episode.name) | \(episode.episode)"
            self.likeButton.setImage(self.isLiked ? .tappedLike : .like, for: .normal)
            self.likeButton.tag = tag
            self.didTapOnLike = buttonAction
        }
    }
    
    //MARK: UI
    func layoutUI() {
        episodeImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: 232)
        episodeImageView.center.x = contentView.center.x
        
        nameLabel.frame = CGRect(x: 16, y: episodeImageView.frame.maxY, width: contentView.frame.width, height: 54)
    
        
        watchImageView.frame = CGRect(x: 22, y: nameLabel.frame.maxY + 22, width: 26, height: 26)
        descriptionLabel.frame = CGRect(x: watchImageView.frame.maxX + 8, y: nameLabel.frame.maxY + 22, width: 157, height: 26)
        likeButton.frame = CGRect(x: contentView.frame.maxX - 56, y: nameLabel.frame.maxY + 22, width: 40, height: 40)
        
    }
    
    //MARK: Action
    @objc
    private func didTapLike() {
        isLiked.toggle()
        likeButton.setImage(isLiked ? .tappedLike : .like, for: .normal)
        if isLiked {
            UserDefaultsService().add(with: currentEpisode?.id ?? 33)
        } else {
            UserDefaultsService().delete(with: currentEpisode?.id ?? 33)
        }
        improveUX()
        didTapOnLike(likeButton)
    }
    
    //MARK: Private methods
    private func improveUX() {
        let mediumGenerator = UIImpactFeedbackGenerator(style: .light)
          mediumGenerator.prepare()
          mediumGenerator.impactOccurred()
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
              let lightGenerator = UIImpactFeedbackGenerator(style: .light)
              lightGenerator.prepare()
              lightGenerator.impactOccurred()
          }

        UIView.animate(withDuration: 0.1, animations: {
            self.likeButton.transform = CGAffineTransform(scaleX: 0.55, y: 0.55)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.likeButton.transform = CGAffineTransform.identity
            }
        }
    }
    
}
