//
//  MainViewController.swift
//  ABLY
//
//  Created by apple on 2021/06/18.
//

import UIKit

class MainViewController: UITabBarController {

    enum Constant {
        static let homeTabTitle = "홈"
        static let favoriteTabTitle = "좋아요"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = .red
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem.title = Constant.homeTabTitle
        homeVC.tabBarItem.selectedImage = UIImage(named: "iconHomeActive")
        homeVC.tabBarItem.image = UIImage(named: "iconHome")
        
        let favoriteVC = FavoriteViewController()
        favoriteVC.tabBarItem.title = Constant.favoriteTabTitle
        favoriteVC.tabBarItem.selectedImage = UIImage(named: "iconZzimActive")
        favoriteVC.tabBarItem.image = UIImage(named: "iconZzim")
        
        viewControllers = [homeVC, favoriteVC]
        // Do any additional setup after loading the view.
    }

}
