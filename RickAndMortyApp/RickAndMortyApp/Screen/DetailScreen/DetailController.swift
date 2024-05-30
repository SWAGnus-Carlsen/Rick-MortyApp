//
//  DetailController.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 24.05.24.
//

import UIKit

final class DetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: UIElements
    private lazy var characterImageView: UIImageView = makeCharacterImageView()
    private lazy var changeImageButton: UIButton = makeChangeImageButton()
    private lazy var nameLabel: UILabel = makeNameLabel()
    private lazy var infoLabel: UILabel = makeInfoLabel()
    private var characterInfoTable: UITableView = UITableView()
    
    //MARK: Properties
    private var character: CharacterResponse
    
    //MARK: Constructor
    init(character: CharacterResponse) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
        #warning("Network service should be injected here")
        NetworkService().getImage(with: character.id, for: characterImageView)
        nameLabel.text = character.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCharacterInfoTableView()
        setupConstraints()
    }
    
    //MARK: Methods
    private func showImagePicker(with sourceType: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    private func showChangePhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Загрузите изображение", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            self?.showImagePicker(with: .camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
            self?.showImagePicker(with: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    //MARK: Action
    @objc
    private func didTapOnChangePhoto() {
        showChangePhotoActionSheet()
    }
  

}

//MARK: - UI
private extension DetailController {
    func setupUI() {
        view.backgroundColor = .white
    }
    
    func setupConstraints() {
        view.addSubview(characterImageView)
        view.addSubview(changeImageButton)
        view.addSubview(nameLabel)
        view.addSubview(infoLabel)
        view.addSubview(characterInfoTable)
        
        NSLayoutConstraint.activate([
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 148),
            characterImageView.heightAnchor.constraint(equalToConstant: 148),
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            
            changeImageButton.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
            changeImageButton.widthAnchor.constraint(equalToConstant: 32),
            changeImageButton.heightAnchor.constraint(equalToConstant: 32),
            changeImageButton.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 32),
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 32),
            
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoLabel.heightAnchor.constraint(equalToConstant: 32),
            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),

            characterInfoTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            characterInfoTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            characterInfoTable.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            characterInfoTable.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -120)
            
        ])
        
    }
    
    func makeCharacterImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 74
        return iv
    }
    
    func makeChangeImageButton() -> UIButton {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(didTapOnChangePhoto), for: .touchUpInside)
        b.setImage(.cameraSign, for: .normal)
        return b
    }
    
    func makeNameLabel() -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        l.textAlignment = .center
        l.adjustsFontSizeToFitWidth = true
        return l
    }
    
    func makeInfoLabel() -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        l.textAlignment = .left
        l.textColor = .gray
        l.text = "Informations"
        l.adjustsFontSizeToFitWidth = true
        return l
    }
}

//MARK: - Table View
extension DetailController {
    
    //MARK: Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChracterInfoTableCell.identifier, for: indexPath) as? ChracterInfoTableCell else  {
            return UITableViewCell()
        }
        cell.configure(for: indexPath.row, character)
        
        return cell
    }
    
    
    //MARK: Setup func
    func setupCharacterInfoTableView() {
        characterInfoTable.delegate = self
        characterInfoTable.dataSource = self
        characterInfoTable.translatesAutoresizingMaskIntoConstraints = false
        //characterInfoTable.isUserInteractionEnabled = false
        characterInfoTable.register(ChracterInfoTableCell.self, forCellReuseIdentifier: ChracterInfoTableCell.identifier)
        characterInfoTable.separatorStyle = .none
        characterInfoTable.rowHeight = 64
    }
    
    
}

//MARK: - ImagePickerDelegate
extension DetailController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            characterImageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

#Preview(String(describing: DetailController.self)) {
    DetailController(character: CharacterResponse(id: 1, name: "Haaland", status: "Alive", species: "Alien", type: "kk", gender: "Male", origin: Location(name: "Yorkshir", url: ""), location: Location(name: "Mancity", url: ""), image: "", episode: [], url: "", created: ""))
}
