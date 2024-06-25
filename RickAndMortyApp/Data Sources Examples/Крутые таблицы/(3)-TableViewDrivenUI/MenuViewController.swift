//
//  MenuViewController.swift
//  CombineTests
//

import UIKit

extension UITableViewCell {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}

final class MenuViewController: UIViewController, UITableViewDelegate {
	fileprivate typealias Category = MenuCategory
	fileprivate typealias DataSource = MenuDataSource
	
	private lazy var tableView: UITableView = makeTableView()
	private lazy var dataSource: DataSource = makeDataSource()
	
	private let baseTintColor = UIColor.systemGreen
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		configureDataSource()
	}
}

// MARK: - UI
private extension MenuViewController {
	func configureUI() {
		view.backgroundColor = .white
		view.tintColor = baseTintColor
		view.addSubview(tableView)
		configureNavBar()
	}
	
	func configureNavBar() {
		title = MenuCategory.title
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
	}

	func makeTableView() -> UITableView {
		tableView = UITableView(frame: view.bounds, style: .insetGrouped)
		//tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		tableView.backgroundColor = .systemGroupedBackground
		//		tableView.separatorStyle = .none
		//		tableView.tableFooterView = UIView()
		tableView.delegate = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
		return tableView
	}
	
	func makeDataSource() -> DataSource {
		DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
			let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
			cell.imageView?.image = UIImage(systemName: item.imageName)
			cell.textLabel?.text = item.title
			cell.textLabel?.numberOfLines = 0
			cell.accessoryType = .disclosureIndicator
			return cell
		})
	}
	
	func configureDataSource() {
		// setup type of animation
		dataSource.defaultRowAnimation = .left//.fade
		
		// setup initial snapshot
		var snapshot = NSDiffableDataSourceSnapshot<Category, Category.Item>()
		
		// populate snapshot with sections and items for each section
		// CaseIterable allows us to iterate through all the cases of an enum
		for category in Category.allCases { // all cases from the Category enum
			// filter the testData() [items] for that particular category's items
			let items = Category.Item.fetchData().filter { $0.category == category }
			snapshot.appendSections([category]) // add section to table view
			snapshot.appendItems(items)
		}
		dataSource.apply(snapshot, animatingDifferences: false)
	}
}

#Preview("Test") {
	UINavigationController(rootViewController: MenuViewController())
}
