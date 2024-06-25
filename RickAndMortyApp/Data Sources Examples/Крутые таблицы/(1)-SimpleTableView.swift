//
//  SimpleTableView.swift
//  CombineTests
//
//

import UIKit
import SwiftUI
// TableView Simple

class SomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	var tableView = UITableView()
	var datas: [String] = ["1", "2", "3", "4", "5"]
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
	}
	
	func setupTableView() {
		title = "TableView Simple"
		tableView.frame = view.bounds
		tableView.tableHeaderView = UIView()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		tableView.dataSource = self
		tableView.delegate = self
		view.addSubview(tableView)
	}
}

// MARK: - UITableViewDataSource
extension SomeViewController  {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return datas.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = datas[indexPath.row]
		return cell
	}
}

// MARK: - UITableViewDelegate
extension SomeViewController {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped at \(indexPath.row)")
	}
}

#Preview("SimpleTableView11") {
	UINavigationController(rootViewController: SomeViewController())
}

