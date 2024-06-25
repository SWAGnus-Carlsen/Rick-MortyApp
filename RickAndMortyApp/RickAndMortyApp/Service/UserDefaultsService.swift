//
//  UserDefaultsService.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 29.05.24.
//

import Foundation

//CRUD
protocol IUserDefaultsService {
    func save(array: [Int])
    func retrieve() -> [Int]
    func add(with id: Int)
    func delete(with id: Int)
}

final class UserDefaultsService: IUserDefaultsService {
    func save(array: [Int]) {
        UserDefaults.standard.set(array, forKey: "Fav_episodes_id")
    }
    
    func retrieve() -> [Int] {
        let retrievedIDs =  UserDefaults.standard.value(forKey: "Fav_episodes_id") as? [Int] ?? []
        print(retrievedIDs)
        return retrievedIDs
       
    }
    
    func add(with id: Int) {
        var existingIds = retrieve()
        guard !existingIds.contains(id) else { return }
        existingIds.append(id)
        print("Saved ids after Add: \(existingIds)")
        save(array: existingIds)
    }
    
    func delete(with id: Int) {
        var existingIds = retrieve()
        guard let indexToRemove = existingIds.firstIndex(of: id) else { return }
        existingIds.remove(at: indexToRemove)
        print("Saved ids after delete: \(existingIds)")
        save(array: existingIds)
    }
}
