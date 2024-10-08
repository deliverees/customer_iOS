//
//  SaveUserLocationUseCase.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 8/10/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import Foundation

struct SaveUserLocationUseCase {
    typealias UseCase = () async throws -> Void
    private let repository = CommomParsing()
    func execute() async throws {
        guard login_session.isUserLogged() else {
            return
        }
        let language = login_session.value(forKey: "Language") as? String ?? "es"
        guard let passLat = login_session.value(forKey: "user_latitude") as? String,
              let passLong = login_session.value(forKey: "user_longitude") as? String,
              let passAddress = login_session.value(forKey: "user_address") as? String
        else {
            throw NSError(domain: "com.deliverees.error", code: -1)
        }
        let passZipCode = login_session.value(forKey: "user_zip_code") as? String ?? ActAsSelectedZipCode
        let userAdditionalAddress = login_session.value(forKey: "user_additional_address") as? String ?? ""
        return try await withCheckedThrowingContinuation { continuation in
            repository.saveShippingAddress(lang: language, search_latitude: passLat, search_longitude: passLong, zipcode: passZipCode, location: passAddress, address: userAdditionalAddress, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200
                {
                    continuation.resume()
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
            }, onFailure: {errorResponse in
                if let errorResponse {
                    continuation.resume(throwing: errorResponse)
                }
            })
        }
    }
}
