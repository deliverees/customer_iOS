//
//  SaveCartShippingAddressUseCase.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 18/10/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import Foundation

struct SaveCartShippingAddressRequestDTO {
    let customerFirstName: String
    let customerLastName: String
    let customerEmail: String
    let customerPhone1: String
    let customerPhone2: String
    let address: String
    let additionalAddress: String
    let latitude: Double
    let longitude: Double
    let zipCode: String
}

struct SaveCartShippingAddressResponseDTO {
    let code: Int
}

struct SaveCartShippingAddressUseCase {
    typealias UseCase = (SaveCartShippingAddressRequestDTO) async throws -> SaveCartShippingAddressResponseDTO
    
    private let repository = CommomParsing()
    
    func execute(_ request: SaveCartShippingAddressRequestDTO) async throws -> SaveCartShippingAddressResponseDTO {
        guard login_session.isUserLogged() else {
            throw "Logout request not supported"
        }
        let lang = login_session.selectedLanguage()
        
        return try await withCheckedThrowingContinuation { continuation in
            repository.updateUserShippingAddress(lang: lang,
                                                 sh_cus_fname: request.customerFirstName,
                                                 sh_cus_lname: request.customerLastName,
                                                 sh_cus_email: request.customerEmail,
                                                 sh_phone1: request.customerPhone1,
                                                 sh_phone2: request.customerPhone2,
                                                 sh_location: request.address,
                                                 sh_latitude: String(request.latitude),
                                                 sh_longitude: String(request.longitude),
                                                 sh_zipcode: request.zipCode,
                                                 sh_location1: request.additionalAddress) { dictionaryResponse in
                guard let code = dictionaryResponse.value(forKey: "code") as? Int else {
                    continuation.resume(throwing: "Invalid response mapping: \(dictionaryResponse)")
                    return
                }
                continuation.resume(returning: .init(code: code))
            } onFailure: { error in
                if let error {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
