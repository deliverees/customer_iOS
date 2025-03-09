//
//  NSError+ExpressibleByStringLiteral.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 16/10/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import Foundation

extension String: @retroactive Error, @retroactive LocalizedError {
    public var errorDescription: String? {
        self
    }
    
    public var recoverySuggestion: String? {
        "Error: \(self)"
    }
}
