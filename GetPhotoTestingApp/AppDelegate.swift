//
//  AppDelegate.swift
//  GetPhotoTestingApp
//
//  Created by user on 30.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navVC = UINavigationController()
        let coordinator = MainCoordinator(navVC)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        coordinator.start()
        return true
    }
}
