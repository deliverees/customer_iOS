//
//  UserSession.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 18/7/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import Foundation

extension UserDefaults {
    func isUserLogged() -> Bool {
        bool(forKey: "user_logged")
    }
    
    func setUserLogged(_ value: Bool) {
        setValue(value, forKey: "user_logged")
    }
    
    func selectedLanguage() -> String {
        string(forKey: "Language") ?? ""
    }
}
