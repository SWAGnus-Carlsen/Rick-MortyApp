//
//  SplashController.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 16.05.24.
//

import UIKit

final class SplashController: UIViewController {

    //MARK: UI Elements
    private lazy var portalImageView: UIImageView = makePortalImageView()
    private lazy var rickAndMortySign: UIImageView = makeRickAndMortySign()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConsraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animate()
        }
    }


}

//MARK: - UI
private extension SplashController {
    func makeRickAndMortySign() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = .rickAndMortySign
        return iv
    }
    
    func makePortalImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = .loadingPortal
        return iv
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    func setupConsraints() {
        view.addSubview(portalImageView)
        NSLayoutConstraint.activate([
            portalImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            portalImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            portalImageView.widthAnchor.constraint(equalToConstant: 200),
            portalImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        view.addSubview(rickAndMortySign)
        NSLayoutConstraint.activate([
            rickAndMortySign.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 42),
            rickAndMortySign.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func animate() {

        
        
        self.portalImageView.rotate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let vc = HomeController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
}

extension UIView {
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 8)
        rotation.duration = 4
        //rotation.isCumulative = true
        //rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
