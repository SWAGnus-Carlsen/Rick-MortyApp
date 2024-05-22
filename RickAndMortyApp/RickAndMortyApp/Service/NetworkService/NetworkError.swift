//
//  NetworkError.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 22.05.24.
//

import Foundation

enum NetworkError: LocalizedError {
    case decodingError(Error)
    case requestError(Error)
    case emptyData
    case imageFetchingError
    
    public var errorDescription: String {
        switch self {
        case .decodingError(let error): return "Error occured while decoding : \(error)"
        case .requestError(let error): return "Fetching error : \(error)"
        case .imageFetchingError: return "Image fetching error"
        case .emptyData: return "Request returned an empty data"
        }
    }
}

