//
//  AppRouter.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 18/7/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import Foundation
import SWRevealViewController
import CoreLocation

final class AppRouter {
    public static var shared: AppRouter = AppRouter()
    
    private var root: UIViewController?
    
    func initialize() {
        var window = UIWindow()
        if login_session.object(forKey: "user_longitude") != nil {
            window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "RevealRootView") as! SWRevealViewController
            tabBarSelectedIndex = 2
            window.rootViewController = mainViewController
            window.makeKeyAndVisible()
            self.root = mainViewController
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
            initialViewController.ComingType = "FIRST"
            MapLocationPageFrom = ""
            window.rootViewController = initialViewController
            window.makeKeyAndVisible()
            self.root = initialViewController
        }
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
    }
    
    func presentLogin(in viewController: UIViewController? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        loginViewController.modalPresentationStyle = .fullScreen
        if let viewController {
            viewController.present(loginViewController, animated: true)
        } else {
            root?.present(loginViewController, animated: true)
        }
    }
    
    func popToRoot() {
        root?.presentedViewController?.dismiss(animated: true)
        root?.navigationController?.popToRootViewController(animated: true)
    }
    
    func presentMapLocation(from vc: UIViewController,
                            userLocation: CLLocationCoordinate2D? = nil,
                            completion: @escaping MapLocationPage.SelectedLocationCompletionHandler) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MapLocationPage") as! MapLocationPage
        nextViewController.currentSelectedUserLocation = userLocation
        nextViewController.completion = completion
        vc.present(nextViewController, animated: true)
    }
    
    func presentLocationOption(from vc: UIViewController, comingType: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
        nextViewController.ComingType = comingType
        vc.present(nextViewController, animated:true, completion:nil)
    }
    
    func presentInRoot(vc: UIViewController) {
        if root == nil {
            initialize()
        }
        dismissAnyOtherModal()
        root?.present(vc, animated: true)
    }
    
    private func dismissAnyOtherModal() {
        if root?.presentedViewController != nil {
            root?.presentedViewController?.dismiss(animated: false)
        }
        
        if let presented = root?.children.first(where: { $0.presentedViewController != nil }) {
            presented.presentedViewController?.dismiss(animated: false)
        }
    }
}
