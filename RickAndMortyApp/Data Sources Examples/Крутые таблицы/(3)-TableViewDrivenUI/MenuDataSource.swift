//
//  MenuDataSource.swift
//  CombineTests
//

import UIKit
// conforms to UITableViewDataSource
final class MenuDataSource: UITableViewDiffableDataSource<MenuCategory, MenuCategory.Item> {
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return MenuCategory.allCases[section].rawValue
	}
}
