//
//  CheckShippingAddressUseCase.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 18/10/24.
//  Copyright © 2024 apple4. All rights reserved.
//

import Foundation

struct CheckShippingAddressRequestDTO {
    let user_lat: Double
    let user_long: Double
    let store_id: Int
}

struct CheckShippingAddressResponseDTO: Decodable {
    let message: String
    let status: Status
    
    enum Status: Int, Decodable {
        case invalid = 0
        case valid = 1
    }
}

struct CheckShippingAddressUseCase {
    typealias UseCase = (CheckShippingAddressRequestDTO) async throws -> CheckShippingAddressResponseDTO
    
    private let network = CommomParsing()
    func execute(_ request: CheckShippingAddressRequestDTO) async throws -> CheckShippingAddressResponseDTO {
        guard login_session.isUserLogged() else {
            throw "User not logged in"
        }
        let language = login_session.value(forKey: "Language") as? String ?? "es"
        let passLat = String(request.user_lat)
        let passLong = String(request.user_long)
        let store_id = String(request.store_id)
        
        return try await withCheckedThrowingContinuation { continuation in
            network.checkShippingAddress(lang: language,
                                         user_latitude: passLat,
                                         user_longitude: passLong,
                                         storeId: store_id) { dictionaryResponse in
                print(dictionaryResponse)
                guard let message = dictionaryResponse.value(forKey: "message") as? String,
                      let statusInt = dictionaryResponse.value(forKey: "status") as? Int,
                      let status = CheckShippingAddressResponseDTO.Status(rawValue: statusInt) else {
                    continuation.resume(throwing: "No se pudo recibir la respuesta correctamente, \(dictionaryResponse)")
                    return
                }
                
                continuation.resume(returning: .init(message: message,
                                                     status: status))
            } onFailure: { error in
                if let error {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
