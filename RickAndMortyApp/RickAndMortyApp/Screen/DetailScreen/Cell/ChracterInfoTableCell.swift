//
//  ChracterInfoTableCell.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 24.05.24.
//

import UIKit

final class ChracterInfoTableCell: UITableViewCell {
    
    //MARK: ID
    static let identifier = String(describing: ChracterInfoTableCell.self)
    
    //MARK: UI Elements
    private lazy var categoryNameLabel: UILabel = makeCategoryNameLabel()
    private lazy var infoLabel: UILabel = makeInfoLabel()
  
    
    //MARK: Override methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

       // contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: Methods
    public func configure(for row: Int, _ character: CharacterResponse) {
        switch row {
        case 0:
            categoryNameLabel.text = "Gender"
            infoLabel.text = character.gender
        case 1:
            categoryNameLabel.text = "Status"
            infoLabel.text = character.status
        case 2:
            categoryNameLabel.text = "Specie"
            infoLabel.text = character.species
        case 3:
            categoryNameLabel.text = "Origin"
            infoLabel.text = character.origin.name
        case 4:
            categoryNameLabel.text = "Type"
            infoLabel.text = character.type
        case 5:
            categoryNameLabel.text = "Location"
            infoLabel.text = character.location.name
        default:
            categoryNameLabel.text = "This shouldn't be shown"
            infoLabel.text = character.url
        }
        
    }
    
    
    
}

//MARK: - UI
private extension ChracterInfoTableCell {
    func setupUI() {
    
        contentView.addSubview(categoryNameLabel)
        contentView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            categoryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            categoryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            infoLabel.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 4),
        ])
        
    }
    
    func makeCategoryNameLabel() -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textColor = .black
        return l
    }
    
    func makeInfoLabel() -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 14)
        l.textColor = .gray
        return l
    }
}
