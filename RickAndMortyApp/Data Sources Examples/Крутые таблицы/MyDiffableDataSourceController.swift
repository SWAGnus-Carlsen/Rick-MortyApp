//
//  MyDiffableDataSourceController.swift
//  RickAndMortyApp
//
//  Created by Vitaliy Halai on 12.06.24.
//

import UIKit


final class MyDiffableDataSourceController: UIViewController, UITableViewDelegate {
    enum Section {
        case first
    }
    struct Fruit: Hashable {
        let title: String
        let id = UUID()
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .insetGrouped)
        t.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return t
    }()
    var dataSource: UITableViewDiffableDataSource<Section, Fruit>!
    var fruits = [Fruit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model.title
            return cell
        })
        title = "My Fruits"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAdd))
        
        dataSource.defaultRowAnimation = .fade

    }
    
    
    @objc
    private func didTapAdd() {
        let actionSheet = UIAlertController(title: "Select fruit", message: nil, preferredStyle: .actionSheet)
        for x in 0...10 {
            actionSheet.addAction(UIAlertAction(title: "Fruit \(x+1)", style: .default, handler: { [weak self] _ in
                let fruit = Fruit(title: "Fruit \(x+1)")
                self?.fruits.append(fruit)
                self?.updateDataSource()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Fruit>()
        snapshot.appendSections([.first])
        snapshot.appendItems(fruits, toSection: .first)
        
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let fruit = dataSource.itemIdentifier(for: indexPath) else { return }
        print(fruit.id)
    }
    
}

#Preview("MyDiffableDataSourceController") {
    UINavigationController(rootViewController: MyDiffableDataSourceController())
}
