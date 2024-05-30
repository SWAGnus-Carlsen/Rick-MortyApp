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
    case cannotConvertImage
    case imageFetchingError
    case badURL
    
    public var errorDescription: String {
        switch self {
        case .decodingError(let error): return "Error occured while decoding : \(error)"
        case .requestError(let error): return "Fetching error : \(error)"
        case .imageFetchingError: return "Image fetching error"
        case .emptyData: return "Request returned an empty data"
        case .cannotConvertImage: return "Cannot convert image from data"
        case .badURL: return "Cannot make a proper URL"
        }
    }
}

