//
//  Localization.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 13/8/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import Foundation

struct Localization {
    static func value(for key: String) -> String {
        if isRunningTests {
            return key
        }
        if let val = LanguageDictonary.value(forKey: key) as? String {
            return val
        }
        assertionFailure("Value not found, did you forget to add it to Localization files? (Spanish.json, English.json")
        return ""
    }
}
