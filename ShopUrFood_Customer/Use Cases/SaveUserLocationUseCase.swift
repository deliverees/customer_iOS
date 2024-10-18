//
//  SaveUserLocationUseCase.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 8/10/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import Foundation

struct SaveUserLocationUseCase {
    typealias UseCase = (ChangeAddressDTO) async throws -> Void
    private let repository = CommomParsing()
    func execute(_ changeAddress: ChangeAddressDTO) async throws {
        let language = login_session.selectedLanguage()
        let passLat = String(changeAddress.latitude)
        let passLong = String(changeAddress.longitude)
        guard let passAddress = changeAddress.addressString,
              let passZipCode = changeAddress.zipCode,
              let userAdditionalAddress = changeAddress.addressAdditional
        else {
            throw Localization.value(for: "validlocation")
        }
        login_session.setValue(passLat, forKey: "user_latitude")
        login_session.setValue(passLong, forKey: "user_longitude")
        login_session.setValue(passAddress, forKey: "user_address")
        login_session.set(passZipCode, forKey: "user_zip_code")
        login_session.set(userAdditionalAddress, forKey: "user_additional_address")
        ActAsSelectedAddress = passAddress
        ActAsSelectedLatitude = passLat
        ActAsSelectedLongitude = passLong
        ActAsSelectedZipCode = passZipCode
        guard login_session.isUserLogged() else {
            return
        }
        return try await withCheckedThrowingContinuation { continuation in
            repository.saveShippingAddress(lang: language, search_latitude: passLat, search_longitude: passLong, zipcode: passZipCode, location: passAddress, address: userAdditionalAddress, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200
                {
                    continuation.resume()
                    return
                }
                
                let code = response.object(forKey: "code") as? Int ?? -1
                let message = response.object(forKey: "message") as? String ?? Localization.value(for: "notavailable")
                
                let error = NSError(domain: "com.deliverees.error",
                                    code: code,
                                    userInfo: [
                                        NSLocalizedFailureReasonErrorKey: message,
                                        NSLocalizedFailureErrorKey: message,
                                        NSDebugDescriptionErrorKey: response
                                    ])
                
                continuation.resume(throwing: error)
            }, onFailure: {errorResponse in
                if let errorResponse {
                    continuation.resume(throwing: errorResponse)
                }
            })
        }
    }
}
