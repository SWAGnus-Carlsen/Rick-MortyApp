//
//  Lesson5ViewController.swift
//  CombineTests
//
//

import UIKit
import Combine

// MARK: - Advanced Level

/*
 Empty - Пустой паблишер который возвращает ничего
 */

final class Lesson5ViewModel/*: ObservableObject*/ {
	@Published var dataToView: [String] = []
	var cancellable: Set<AnyCancellable> = []
    
	let datas = ["Value 1", "Value 2", "Value 3", nil,"Value 5", "Value 6", nil, nil]
	
	func fetch() {
		_ = datas.publisher
			.flatMap { item -> AnyPublisher<String, Never> in //flatMap работает с Optional
				if let item {
                    return Deferred(createPublisher: { Just(item) } )  // Call 1 time
						.eraseToAnyPublisher()
				} else {
					return Empty(completeImmediately: true) // Not Set Data
						.eraseToAnyPublisher()
				}
			}
            //.compactMap({ $0 })
			.sink(receiveValue: { [unowned self] item in
                dataToView.append(item)
			})
        
        
	}
}

final class Lesson5ViewController: UIViewController {
	var viewModel = Lesson5ViewModel()
	var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Empty Publisher"
		
		setupTableView()
		bind()
		viewModel.fetch()
	}
	
	func setupTableView() {
		tableView.frame = view.bounds
		tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		view.addSubview(tableView)
	}
	
	func bind() {
		viewModel.$dataToView
			.sink(receiveValue: tableView.items { tableView, indexPath, item in
				let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
				cell.textLabel?.text = item
				return cell
			})
			.store(in: &viewModel.cancellable)
	}
}


// MARK: - Extensions
extension UITableView {
    func items<Element>(_ builder: @escaping (UITableView, IndexPath, Element) -> UITableViewCell) -> (([Element]) -> Void) {
		let dataSource = CombineTableViewDataSource(builder: builder)
		return { items in
			dataSource.pushElements(items, to: self)
		}
	}
}

final class CombineTableViewDataSource<Element>: NSObject, UITableViewDataSource {
	let build: (UITableView, IndexPath, Element) -> UITableViewCell
	var elements: [Element] = []
	
	init(builder: @escaping (UITableView, IndexPath, Element) -> UITableViewCell) {
		self.build = builder
		super.init()
	}
	
	func pushElements(_ elements: [Element], to tableView: UITableView) {
		tableView.dataSource = self
		self.elements = elements
		tableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		elements.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		build(tableView, indexPath, elements[indexPath.row])
	}
}


#Preview("Lesson5") {
	UINavigationController(rootViewController: Lesson5ViewController()) //without Preview UIKit lol
}
