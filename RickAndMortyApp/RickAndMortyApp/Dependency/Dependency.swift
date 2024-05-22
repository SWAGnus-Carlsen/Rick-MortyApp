//
//  Dependency.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 22.05.24.
//

import Foundation

protocol IDependency {
    var networkService: INetworkService { get }
}

final class Dependency: IDependency {
    lazy var networkService: INetworkService = NetworkService()
}
