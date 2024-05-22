//
//  NetworkService.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 22.05.24.
//

import Foundation

protocol INetworkService {
    func getEpisodes(_ completion: @escaping (Result<EpisodesResponse, NetworkError>) -> Void)
}

final class NetworkService: INetworkService {
    
    func getEpisodes(_ completion: @escaping (Result<EpisodesResponse, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://rickandmortyapi.com/api/episode?page=1")!)) { data,_,error in
            if error != nil {
                print("Episodes fetch error")
            }
            
            guard let data else { return }
            do {
                print(data.prettyPrintedJSONString)
                let response = try JSONDecoder().decode(EpisodesResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
            
        }.resume()
    }
    
    
}
