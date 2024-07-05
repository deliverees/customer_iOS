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

class LocationOptionPage: BaseViewController,CLLocationManagerDelegate {

    @IBOutlet weak var baCKBTN: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var manualLocBtn: UIButton!
    //@IBOutlet weak var currentLocBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var allowLocation = Bool()
    var addressString : String = ""
    var window: UIWindow?
    var resultDict1 = NSMutableDictionary()
    var ComingType = String()

   
    @IBOutlet weak var animationView: UIView!
    
    private var tempView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.layer.cornerRadius = 2.0
        baseView.addShadow()
        //currentLocBtn.layer.cornerRadius = 25.0
        //manualLocBtn.layer.cornerRadius = 25.0
        manualLocBtn.clipsToBounds = true
        let Text = (LanguageDictonary.object(forKey: "setdeliverylocation") as! String).uppercased()
        self.manualLocBtn.setTitle(Text, for: .normal)
        
        
        if self.ComingType == "FIRST" {
            self.ComingType = ""
            self.baCKBTN.isHidden = true
        }else{
            self.baCKBTN.isHidden = false
        }
        
        // 1. Set animation content mode
        
        tempView = .init(name: "anim_location")
          
        //tempView!.frame = view.bounds
        tempView!.frame = CGRect(x:0, y:0, width: 200, height: 200)
        animationView.addSubview(tempView!)
        
        tempView?.play()
        // Do any additional setup after loading the view.
        
    }
    
//    @IBAction func currentLocBtnAction(_ sender: Any) {
//        // Ask for Authorisation from the User.
//        self.locManager.requestAlwaysAuthorization()
//        allowLocation = true
//        var showAlertSetting = false
//        var showInitLocation = false
//
//        // For use in foreground
//        self.locManager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled()
//        {
//            switch CLLocationManager.authorizationStatus() {
//            case .denied:
//                showAlertSetting = true
//                print("HH: kCLAuthorizationStatusDenied")
//            case .restricted:
//                showAlertSetting = true
//                print("HH: kCLAuthorizationStatusRestricted")
//            case .authorizedAlways:
//                showInitLocation = true
//                print("HH: kCLAuthorizationStatusAuthorizedAlways")
//            case .authorizedWhenInUse:
//                showInitLocation = true
//                print("HH: kCLAuthorizationStatusAuthorizedWhenInUse")
//            case .notDetermined:
//                showInitLocation = true
//                print("HH: kCLAuthorizationStatusNotDetermined")
//            default:
//                break
//            }
//
//        }
//        else
//        {
//            showAlertSetting = true
//            print("HH: locationServicesDisabled")
//        }
//        
//        if showAlertSetting
//        {
//            let alertController = UIAlertController(title: "Alert", message: "Please enable location service in the settings", preferredStyle: .alert)
//            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//                
//                if let url = URL(string: UIApplication.openSettingsURLString) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//                
//            }
//            alertController.addAction(OKAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//        else
//        {
//            locManager.delegate = self
//            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locManager.startUpdatingLocation()
//
//        }
//    }
    
    func getCartData()
    {
        let Parse = CommomParsing()
        Parse.getMyCartData(lang: login_session.value(forKey: "Language")as? String ?? "en", onSuccess: {
            response in
            if response.object(forKey: "code") as! Int == 200
            {
                print (response)
                let mod = MyCartModel(fromDictionary: response as! [String : Any])
                Singleton.sharedInstance.MyCartModel = mod
                self.resultDict1.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                globalCartCount = (((self.resultDict1.value(forKey: "cart_details") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "added_item_details") as? NSArray)!.count
                
                var showAlertSetting = false
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MapLocationPage") as! MapLocationPage
                MapLocationPageFrom = "login"
                self.present(nextViewController, animated:true, completion:nil)
                
            }
            else if response.object(forKey: "code")as! Int == 400
            {
             globalCartCount = 0
                var showAlertSetting = false
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MapLocationPage") as! MapLocationPage
                MapLocationPageFrom = "login"
                self.present(nextViewController, animated:true, completion:nil)
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                //self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
                
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    
    func saveShippingAddress()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.saveShippingAddress(lang: login_session.value(forKey: "Language") as? String ?? "es", search_latitude: login_session.object(forKey: "user_latitude") as! String, search_longitude: login_session.object(forKey: "user_longitude") as! String, zipcode:ActAsSelectedZipCode, location: self.addressString, address: "", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
                
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                print(response.object(forKey: "message") as Any)
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }

    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func manualLocBtnAction(_ sender: Any) {
        
        self.getCartData()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if allowLocation{
            allowLocation = false
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
       
        let lat = String(locValue.latitude)
        let longt = String(locValue.longitude)
        
        login_session.setValue(lat, forKey: "user_latitude")
        login_session.setValue(longt, forKey: "user_longitude")
        self.getAddressFromLatLon(pdblLatitude: lat, pdblLongitude: longt)
        login_session.synchronize()
        self.locManager.stopUpdatingLocation()
        print("locations = \(lat) \(longt)")
        }

       
    }
    
    
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    if pm.subThoroughfare != nil {
                        self.addressString = self.addressString + pm.subThoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        self.addressString = self.addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        self.addressString = self.addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        self.addressString = self.addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        self.addressString = self.addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        self.addressString = self.addressString + pm.postalCode! + " "
                        ActAsSelectedZipCode = pm.postalCode!
                    }
                    
                    login_session.setValue(self.addressString, forKey: "user_address")
                    self.saveShippingAddress()
                    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.checkRootView()
                }
        })
    }
}

extension UIView {
    
    func addShadowView() {
        //Remove previous shadow views
        superview?.viewWithTag(119900)?.removeFromSuperview()
        
        //Create new shadow view with frame
        let shadowView = UIView(frame: frame)
        shadowView.tag = 119900
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        shadowView.layer.masksToBounds = false
        
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.layer.shouldRasterize = true
        
        superview?.insertSubview(shadowView, belowSubview: self)
    }}
