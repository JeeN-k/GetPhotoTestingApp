//
//  FavoritesCoordinator.swift
//  GetPhotoTestingApp
//
//  Created by user on 30.05.2023.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .favorites }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Favorites started")
        showPhotoViewController()
    }
    
    private func showPhotoViewController() {
        let dataProvider = DataProvider()
        let favoritesVM = FavoritesViewModel(dataProvider: dataProvider)
        let favoritesVC = FavoritesViewController(viewModel: favoritesVM)
        favoritesVM.view = favoritesVC
        navigationController.pushViewController(favoritesVC, animated: true)
    }
    
    deinit {
        print("FavoritesCoordinator deinited")
    }
}

extension FavoritesCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
