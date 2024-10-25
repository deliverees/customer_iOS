//
//  ChangeAddress.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 16/10/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import Foundation

struct ChangeAddressDTO {
    let latitude: Double
    let longitude: Double
    let addressString: String?
    let addressAdditional: String?
    let zipCode: String?
}

extension ChangeAddressDTO {
    init(from defaults: UserDefaults) throws {
        guard let latitudeString = defaults.string(forKey: "user_latitude"),
              let longitudeString = defaults.string(forKey: "user_longitude"),
              let latitude = Double(latitudeString), let longitude = Double(longitudeString) else {
            throw "Latitude or Longitude not set in defaults"
        }
        
        self.latitude = latitude
        self.longitude = longitude
        self.addressString = defaults.string(forKey: "user_address")
        self.addressAdditional = defaults.string(forKey: "user_additional_address")
        self.zipCode = defaults.string(forKey: "user_zip_code")
    }
}
