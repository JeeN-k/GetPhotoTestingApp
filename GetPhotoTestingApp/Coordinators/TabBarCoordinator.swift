//
//  TabBarCoordinator.swift
//  GetPhotoTestingApp
//
//  Created by user on 30.05.2023.
//

import UIKit

protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
}

final class TabBarCoordinator: NSObject, TabBarCoordinatorProtocol {
    var tabBarController: UITabBarController
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.tabBarController = .init()
        self.navigationController = navigationController
    }
    
    func start() {
        print("TabBar started")
        let pages: [TabBarPage] = [.photo, .favorites]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        let contollers: [UINavigationController] = pages.map({ getTabBarController($0) })
        prepareTabBarController(with: contollers)
    }
    
    private func prepareTabBarController(with tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.photo.pageOrderNumber()
        tabBarController.tabBar.backgroundColor = .white
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabBarController(_ page: TabBarPage) -> UINavigationController {
        let navVC = UINavigationController()
        navVC.tabBarItem = UITabBarItem(title: page.pageTitleValue(),
                                        image: UIImage(named: page.pageImageName()),
                                        selectedImage: UIImage(named: page.selectedPageName()))
        switch page {
        case .photo:
            let photoCoordinator = PhotoCoordinator(navVC)
            photoCoordinator.finishDelegate = self
            childCoordinators.append(photoCoordinator)
            photoCoordinator.start()
        case .favorites:
            let favoritesCoordinator = FavoritesCoordinator(navVC)
            favoritesCoordinator.finishDelegate = self
            childCoordinators.append(favoritesCoordinator)
            favoritesCoordinator.start()
        }
        return navVC
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
