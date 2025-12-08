//
//  PayPalManager.swift
//  ShopUrFood_Customer
//
//  Created by Deliverees on 29/10/25.
//  Copyright © 2025 apple4. All rights reserved.
//  Gestor centralizado para pagos con PayPal
//

import Foundation
import PayPalCheckout

class PayPalManager {
    static let shared = PayPalManager()
    
    private init() {}
    
    // MARK: - Crear orden en el backend
    func createPayPalOrder(
        orderAmount: String,
        customerData: [String: Any],
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Usar la constante existente del proyecto
        guard let url = URL(string: "\(BASEURL_CUSTOMER)paypal/create-order") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Agregar token de autenticación desde login_session
        if let token = login_session.value(forKey: "Login_token") as? String {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Preparar datos
        var requestData = customerData
        requestData["order_amount"] = orderAmount
        requestData["lang"] = login_session.value(forKey: "Language") as? String ?? "es"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            completion(.failure(error))
            return
        }
        
        #if DEBUG
        print("🔵 PayPal createOrder Request:")
        print("URL: \(url)")
        print("Data: \(requestData)")
        #endif
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    #if DEBUG
                    print("🟢 PayPal createOrder Response:")
                    print(json)
                    #endif
                    
                    if let responseData = json["data"] as? [String: Any] {
                        DispatchQueue.main.async {
                            completion(.success(responseData))
                        }
                    } else {
                        let message = json["message"] as? String ?? "Unknown error"
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: message, code: -1, userInfo: nil)))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Invalid JSON", code: -1, userInfo: nil)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - Ejecutar pago en el backend
    func executePayPalPayment(
        paymentId: String,
        payerId: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Usar la constante existente del proyecto
        guard let url = URL(string: "\(BASEURL_CUSTOMER)paypal/return") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Agregar token de autenticación desde login_session
        if let token = login_session.value(forKey: "Login_token") as? String {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let requestData: [String: Any] = [
            "paymentId": paymentId,
            "PayerID": payerId,
            "lang": login_session.value(forKey: "Language") as? String ?? "es"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            completion(.failure(error))
            return
        }
        
        #if DEBUG
        print("🔵 PayPal execute Request:")
        print("URL: \(url)")
        print("Data: \(requestData)")
        #endif
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    #if DEBUG
                    print("🟢 PayPal execute Response:")
                    print(json)
                    #endif
                    
                    let code = json["code"] as? Int ?? 400
                    if code == 200 {
                        DispatchQueue.main.async {
                            completion(.success(json))
                        }
                    } else {
                        let message = json["message"] as? String ?? "Payment failed"
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: message, code: code, userInfo: nil)))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Invalid JSON", code: -1, userInfo: nil)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - Iniciar flujo de pago con PayPal
    func startPayPalCheckout(
        from viewController: UIViewController,
        orderAmount: String,
        customerData: [String: Any],
        onSuccess: @escaping (String) -> Void,
        onCancel: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        // 1. Crear orden en el backend
        createPayPalOrder(orderAmount: orderAmount, customerData: customerData) { result in
            switch result {
            case .success(let data):
                guard let paymentId = data["payment_id"] as? String,
                      let approvalUrl = data["approval_url"] as? String else {
                    onError(NSError(domain: "Missing payment data", code: -1, userInfo: nil))
                    return
                }
                
                #if DEBUG
                print("✅ Payment ID: \(paymentId)")
                print("✅ Approval URL: \(approvalUrl)")
                #endif
                
                // 2. Configurar PayPal Checkout usando las constantes del proyecto
                let config = CheckoutConfig(
                    clientID: PAYPAL_CLIENT_ID,
                    createOrder: { action in
                        // Usar el orderId del backend
                        action.set(orderId: paymentId)
                    },
                    onApprove: { approval in
                        #if DEBUG
                        print("✅ PayPal onApprove llamado")
                        print("Order ID: \(approval.data.orderID)")
                        print("Payer ID: \(approval.data.payerID ?? "N/A")")
                        #endif
                        
                        // 3. Ejecutar pago en el backend
                        PayPalManager.shared.executePayPalPayment(
                            paymentId: approval.data.orderID,
                            payerId: approval.data.payerID ?? ""
                        ) { executeResult in
                            switch executeResult {
                            case .success(let response):
                                if let transactionId = response["data"] as? [String: Any],
                                   let txnId = transactionId["transaction_id"] as? String {
                                    onSuccess(txnId)
                                } else {
                                    onSuccess(approval.data.orderID)
                                }
                                
                            case .failure(let error):
                                onError(error)
                            }
                        }
                    },
                    onCancel: {
                        #if DEBUG
                        print("⚠️ PayPal payment cancelled by user")
                        #endif
                        onCancel()
                    },
                    onError: { error in
                        #if DEBUG
                        print("❌ PayPal error: \(error.localizedDescription)")
                        #endif
                        onError(error)
                    },
                    environment: PAYPAL_ENVIRONMENT == "sandbox" ? .sandbox : .live
                )
                
                // 4. Iniciar el flujo de PayPal
                Checkout.set(config: config)
                Checkout.start(presentingViewController: viewController)
                
            case .failure(let error):
                onError(error)
            }
        }
    }
}
