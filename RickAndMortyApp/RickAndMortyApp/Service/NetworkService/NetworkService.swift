//
//  NetworkService.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 22.05.24.
//

import UIKit

protocol INetworkService {
    func getAllEpisodes(forPage: Int, _ completion: @escaping (Result<EpisodesResponse, NetworkError>) -> Void)
    func getCharacter(with urlString: String, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void )
    func getImage(with characterId: Int, for imageView: UIImageView)
    func getCertainEpisodes(withIDs ids: [Int] , _ completion: @escaping (Result<[Episode], NetworkError>) -> Void)
    func getOneEpisode(withID id: Int , _ completion: @escaping (Result<Episode, NetworkError>) -> Void)
    func getFilteredEpisodes(for serie: String , _ completion: @escaping (Result<EpisodesResponse, NetworkError>) -> Void)
}

final class NetworkService: INetworkService {
    
    //MARK: Properties
    private var imagesCache = NSCache<NSString, UIImage>()
    
    //MARK: Interface methods
    func getAllEpisodes(forPage page: Int, _ completion: @escaping (Result<EpisodesResponse, NetworkError>) -> Void) {
        guard page <= 3, page >= 1 else { return }
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://rickandmortyapi.com/api/episode?page=\(page)")!)) { data,_,error in
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
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/avatar/\(characterId).jpeg") else { return }
        
        if let cachedImage = imagesCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                imageView.image = cachedImage
            }
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        URLSession.shared.dataTask(with: request ) { data,_,error in
            if let error {
                print("\(NetworkError.imageFetchingError) in   NetworkService.\(#function)")
            }
            
            guard let data else {
                print("\(NetworkError.emptyData) In function  NetworkService.\(#function)")
                return
            }
            guard let receivedImage = UIImage(data: data) else {
                print("\(NetworkError.cannotConvertImage) In function  NetworkService.\(#function)")
                return
            }
            self.imagesCache.setObject(receivedImage, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                imageView.image = receivedImage
            }
            
            
        }.resume()
    }
    
    func getCertainEpisodes(withIDs ids: [Int] , _ completion: @escaping (Result<[Episode], NetworkError>) -> Void) {
        
        guard let url = makeURLForSeveralEpisodesRequest(forIDs: ids) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data,_,error in
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
                let response = try JSONDecoder().decode([Episode].self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
                print("In function  NetworkService.\(#function)")
            }
            
        }.resume()
    }
    
    func getOneEpisode(withID id: Int , _ completion: @escaping (Result<Episode, NetworkError>) -> Void) {
        
        guard let url = makeURLForSeveralEpisodesRequest(forIDs: [id]) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data,_,error in
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
                let response = try JSONDecoder().decode(Episode.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
                print("In function  NetworkService.\(#function)")
            }
            
        }.resume()
    }
    
    func getFilteredEpisodes(for serie: String , _ completion: @escaping (Result<EpisodesResponse, NetworkError>) -> Void) {
        
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode/?episode=\(serie)") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data,_,error in
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
                print(data.prettyPrintedJSONString)
                let response = try JSONDecoder().decode(EpisodesResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.success(EpisodesResponse(info: Info(count: 0, pages: 0, next: nil, prev: nil), results: [])))
                print("In function  NetworkService.\(#function)")
            }
            
        }.resume()
    }
    
    
    
    
    //MARK: Private methods
    private func makeURLForSeveralEpisodesRequest(forIDs ids: [Int] ) -> URL? {
        var baseURLString = "https://rickandmortyapi.com/api/episode/"
        ids.forEach {
            baseURLString += "\($0),"
        }
        baseURLString.removeLast()
        let url = URL(string: baseURLString)
        return url
    }
}

