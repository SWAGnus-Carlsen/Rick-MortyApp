//
//  TestDrivenUITableView.swift
//  CombineTests
//

import Foundation

enum MenuCategory: String, CaseIterable {
    case open = "OPEN"
    case settings = "SETTINGS"
    case purchases = "PURCHASES"
    
    static let title = "Menu"
    
    struct Item: Hashable {
        let imageName: String
        let title: String
        let category: MenuCategory
        let identifier = UUID()
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        // fetch data
        static func fetchData() -> [Item] {
            return [
                Item(imageName: "book", title: "My Library", category: .open),
                Item(imageName: "globe", title: "Read website", category: .open),
                Item(imageName: "camera.aperture", title: "Read the scan", category: .open),
                Item(imageName: "gear", title: "Settings", category: .settings),
                Item(imageName: "dollarsign.circle", title: "By Additional Features", category: .purchases),
            ]
        }
    }
}
