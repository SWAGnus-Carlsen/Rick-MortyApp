//
//  TableViewDataSource.swift
//  CombineTests
//
//

import UIKit
// TableView DiffableDataSource

class SomeAnotherViewController: UIViewController, UITableViewDelegate {
	enum Section {
		case main
	}
	
	typealias DataSource = UITableViewDiffableDataSource<Section, String>
	typealias Snapshot = NSDiffableDataSourceSnapshot<Section, String>
	
	var dataSource: DataSource?
	
	var datas: [String] = ["1", "2", "3", "4", "5"]
	
	var tableView = UITableView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "TableView DiffableDataSource"
		setupTableView()
		makeDataSource()
		
        updateDataSource(with: datas)
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.updateDataSource(with: ["1", "2", "3"])
        }
    }
    
	func setupTableView() {
		tableView.frame = view.bounds
		tableView.tableHeaderView = UIView()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		tableView.dataSource = dataSource
		tableView.delegate = self
		view.addSubview(tableView)
	}
}


// MARK: DiffableDataSource - Обычно это всё указывают наверху
extension SomeAnotherViewController {
	private func makeDataSource() {
		dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
			cell?.textLabel?.text = item
			return cell
		})
	}
	
    private func updateDataSource(with data: [String]) {
		var snapshot = Snapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(data) // u can send another datas without call reloadData
		dataSource?.apply(snapshot, animatingDifferences: false)
	}
}

// MARK: - UITableViewDelegate
extension SomeAnotherViewController {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("Tapped")
	}
}

import SwiftUI
#Preview("SimpleTableView11") {
	UINavigationController(rootViewController: SomeAnotherViewController())
}
