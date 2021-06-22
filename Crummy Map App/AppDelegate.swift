//
//  AppDelegate.swift
//  Crap Map App
//
//  Created by Joe Crotchett on 6/21/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureWindow()
        return true
    }
    
    // MARK: Private
    
    private func configureWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        StyleGuide.apply(to: window!)
        
        let searchViewController = SearchViewController()
        let navigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.navigationBar.isTranslucent = false
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

