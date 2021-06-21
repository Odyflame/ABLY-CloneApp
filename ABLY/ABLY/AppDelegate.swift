//
//  AppDelegate.swift
//  ABLY
//
//  Created by apple on 2021/06/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        UINavigationBar.appearance().barTintColor = .white
        UITabBar.appearance().barTintColor = .white
        
        let mainVC = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
}

