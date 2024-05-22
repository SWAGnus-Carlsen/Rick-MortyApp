//
//  NetworkService.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 22.05.24.
//

import UIKit

protocol INetworkService {
    func getEpisodes(_ completion: @escaping (Result<EpisodesResponse, NetworkError>) -> Void)
    func getCharacter(with urlString: String, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void )
    func getImage(with characterId: Int, for imageView: UIImageView)
}

final class NetworkService: INetworkService {
    
    func getEpisodes(_ completion: @escaping (Result<EpisodesResponse, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://rickandmortyapi.com/api/episode?page=1")!)) { data,_,error in
            if let error {
                completion(.failure(NetworkError.requestError(error)))
                print("In function  NetworkService.\(#function)")
            }
            
            guard let data else {
                completion(.failure(NetworkError.emptyData))
                print("In function  NetworkService.\(#function)")
                return
            }
            do {
                //print(data.prettyPrintedJSONString)
                let response = try JSONDecoder().decode(EpisodesResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
                print("In function  NetworkService.\(#function)")
            }
            
        }.resume()
    }
    
    func getCharacter(with urlString: String, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void ) {
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: urlString)!)) { data,_,error in
            if let error {
                completion(.failure(NetworkError.requestError(error)))
                print("In function  NetworkService.\(#function)")
            }
            
            guard let data else {
                completion(.failure(NetworkError.emptyData))
                print("In function  NetworkService.\(#function)")
                return
            }
            do {
//                print(data.prettyPrintedJSONString)
                let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
                print("In function  NetworkService.\(#function)")
            }
            
        }.resume()
    }
    
    func getImage(with characterId: Int, for imageView: UIImageView) {
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://rickandmortyapi.com/api/character/avatar/\(characterId).jpeg")!)) { data,_,error in
            if let error {
                print("\(NetworkError.imageFetchingError) in   NetworkService.\(#function)")
            }
            
            guard let data else {
                print("\(NetworkError.emptyData)In function  NetworkService.\(#function)")
                return
            }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
            
            
        }.resume()
    }
    
}
