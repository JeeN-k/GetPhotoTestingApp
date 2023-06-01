//
//  PhotoCoordinator.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 30.05.2023.
//

import UIKit

class PhotoCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .photo }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Photo started")
        showPhotoViewController()
    }
    
    private func showPhotoViewController() {
        let dataProvider = DataProvider()
        let photoViewModel = PhotoViewModel(dataProvider: dataProvider)
        let photoViewController = PhotoViewController(viewModel: photoViewModel)
        photoViewModel.view = photoViewController
        navigationController.pushViewController(photoViewController, animated: true)
    }
    
    deinit {
        print("PhotoCoordinator deinited")
    }
}
extension PhotoCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
