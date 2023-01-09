//
//  CustomTabBarController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 2
        tabBar.items?[0].title = LanguageDictonary.object(forKey: "cartTab") as! String
        tabBar.items?[1].title = LanguageDictonary.object(forKey: "search") as! String
        tabBar.items?[2].title = LanguageDictonary.object(forKey: "home") as! String
        tabBar.items?[3].title = LanguageDictonary.object(forKey: "track") as! String
        tabBar.items?[4].title = LanguageDictonary.object(forKey: "wallet") as! String
        customTabBar = self.tabBar
      
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("\(String(describing: tabBar.items!.index(of: item)))")
        tabBarSelectedIndex = tabBar.items!.index(of: item)!
        isfromFavPage = false
        isfromMyReviewPage = false
    }
    // UITabBarControllerDelegate
    private func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("Selected view controller")
    }
}
