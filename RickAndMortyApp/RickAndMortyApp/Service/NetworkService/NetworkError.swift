//
//  NetworkError.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 22.05.24.
//

import Foundation

enum NetworkError: LocalizedError {
    case decodingError(Error)
    case smthelse
    
    public var errorDescription: String {
        switch self {
        case .decodingError(let error): return "Error occured while decoding episodes: \(error)"
        case .smthelse:
            return ""
        }
    }
}

