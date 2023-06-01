//
//  MainCoordinator.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 30.05.2023.
//

import UIKit

final class MainCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .main }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        showTabBarFlow()
    }
    
    private func showTabBarFlow() {
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
    }
    
    deinit {
        print("MainCoordinator deinited")
    }
}

extension MainCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("Finished")
    }
}
