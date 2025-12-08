//
//  LocationOptionPage.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 13/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Lottie

class LocationOptionPage: BaseViewController, CLLocationManagerDelegate {

    @IBOutlet weak var baCKBTN: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var manualLocBtn: UIButton!
    @IBOutlet weak var subTitleLbl: UILabel!
    var ComingType = String()
    
    @IBOutlet weak var animationView: UIView!
    
    private var tempView: LottieAnimationView?
    
    let locationManager = CLLocationManager()
    var userCountryCode: String = ""
    var hasDetectedLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.layer.cornerRadius = 2.0
        baseView.addShadow()
        manualLocBtn.clipsToBounds = true
        manualLocBtn.setTitle(Localization.value(for: "setdeliverylocation").uppercased(), for: .normal)
        subTitleLbl.numberOfLines = 0
        subTitleLbl.text = Localization.value(for: "location_page_subtitle")
        subTitleLbl.superview?.layer.borderColor = UIColor.systemRed.cgColor
        subTitleLbl.superview?.layer.borderWidth = 3.0
        subTitleLbl.cornerRadius = 4.0
        subTitleLbl.textColor = UIColor.systemRed
        
        if self.ComingType == "FIRST" {
            self.ComingType = ""
            self.baCKBTN.isHidden = true
        } else {
            self.baCKBTN.isHidden = false
        }
        
        // Configurar animación
        tempView = .init(name: "anim_location")
        tempView!.frame = CGRect(x:0, y:0, width: 200, height: 200)
        animationView.addSubview(tempView!)
        tempView?.play()
        
        // Configurar location manager
        setupLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PermissionsManager.shared.requestAuthorizationAndNotificationsPermissions()
        
        // Iniciar detección de ubicación si no se ha detectado
        if !hasDetectedLocation {
            startLocationDetection()
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationDetection() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Permiso de ubicación denegado")
            saveDefaultCountry()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            print("Usuario denegó permisos de ubicación")
            saveDefaultCountry()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error en geocoding: \(error.localizedDescription)")
                self.saveDefaultCountry()
                return
            }
            
            if let placemark = placemarks?.first {
                self.userCountryCode = placemark.isoCountryCode ?? ""
                self.hasDetectedLocation = true
                
                print("País detectado: \(self.userCountryCode)")
                self.saveCountryCodeToUserDefaults()
            } else {
                self.saveDefaultCountry()
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error de ubicación: \(error.localizedDescription)")
        saveDefaultCountry()
    }
    
    func saveCountryCodeToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(userCountryCode, forKey: "userCountryCode")
        defaults.synchronize()
        print("País guardado en UserDefaults: \(userCountryCode)")
    }
    
    func saveDefaultCountry() {
        self.userCountryCode = ""
        self.hasDetectedLocation = true
        saveCountryCodeToUserDefaults()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func manualLocBtnAction(_ sender: Any) {
        AppRouter.shared.presentMapLocation(from: self) { [weak self] newAddress in
            guard let self = self else { return }
            
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.showLoadingIndicator(senderVC: self)
                do {
                    try await SaveUserLocationUseCase().execute(newAddress)
                    
                    // SOLO este print - sin detectCountryFromLocation
                    print("Ubicación manual guardada - País ya detectado: \(self.userCountryCode)")
                    
                    self.dismiss(animated: true)
                } catch {
                    self.showTokenExpiredPopUp(msgStr: error.localizedDescription)
                }
                self.stopLoadingIndicator(senderVC: self)
            }
        }
    }
}
