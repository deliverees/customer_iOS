//
//  UIFont+Trueno.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 8/2/25.
//  Copyright © 2025 apple4. All rights reserved.
//

import UIKit

extension UIFont {
    static func truenoSemiBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "TruenoSBd", size: size) else {
            fatalError("Failed to load the font TruenoSBd. Make sure it's added to the project and the Info.plist.")
        }
        return font
    }
    
    static func truenoBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "TruenoBd", size: size) else {
            fatalError("Failed to load the font TruenoBd. Make sure it's added to the project and the Info.plist.")
        }
        return font
    }
    
    static func truenoRegular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "TruenoRg", size: 16.0) else {
            fatalError("Failed to load the font TruenoRg. Make sure it's added to the project and the Info.plist.")
        }
        return font
    }
}
