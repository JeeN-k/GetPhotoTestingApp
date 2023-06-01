//
//  FavoritesViewController.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 30.05.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoritesImageTableViewCell.self,
                           forCellReuseIdentifier: FavoritesImageTableViewCell.identifier)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    var viewModel: FavoritesViewModelProtocol
    
    init(viewModel: FavoritesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchModels()
    }
}

extension FavoritesViewController: FavoritesViewInputProtocol {
    func didFetchImages() {
        tableView.reloadData()
        navigationItem.title = "Favorites \(viewModel.models.count)/10"
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.models.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesImageTableViewCell.identifier,
                                                       for: indexPath) as? FavoritesImageTableViewCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.viewModelForCell(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeImageAt(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension FavoritesViewController {
    private func configure() {
        navigationItem.title = "Favorites"
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
