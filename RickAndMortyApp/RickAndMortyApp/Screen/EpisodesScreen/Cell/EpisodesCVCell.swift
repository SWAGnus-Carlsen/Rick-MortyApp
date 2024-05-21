//
//  EpisodesCVCell.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 21.05.24.
//

import UIKit

final class EpisodesCVCell: UICollectionViewCell {
    
    //MARK: ID
    static let identifier = String(describing: EpisodesCVCell.self)
    
    //MARK: UI
    private lazy var episodeImageView: UIImageView = {
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
        return l
    }()
    
    private lazy var likeButton: UIButton = {
        let b = UIButton()
        b.setImage(.like, for: .normal)
        b.setImage(.tappedLike, for: .selected)
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
    
        
    }
    
    //MARK: Setup methods
    func setupCell(with episode: Episode) {
        episodeImageView.image = episode.image
        nameLabel.text = episode.name
        
        descriptionLabel.text = "\(episode.description) | \(episode.id)"
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
    
}