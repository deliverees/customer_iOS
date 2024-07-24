//
//  PermissionsManager.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 19/7/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import Foundation
import AppTrackingTransparency
import UserNotifications

final class PermissionsManager {
    public static let shared: PermissionsManager = .init()
    
    private init() { }
    
    func requestAuthorizationAndNotificationsPermissions() {
        DispatchQueue.main.async {
            ATTrackingManager.requestTrackingAuthorization { status in
                print(status)
                DispatchQueue.main.async {
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {(granted, error) in
                        if (granted) {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        } else{
                            print("Notification permissions not granted")
                        }
                    })
                }
            }
        }
    }
}
