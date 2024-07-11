//
//  TrackingScreen.swift
//  ShopUrGrocery_Customer
//
//  Created by apple5 on 25/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import CocoaMQTT

class TrackingScreen: BaseViewController,CLLocationManagerDelegate, GMSMapViewDelegate,UIGestureRecognizerDelegate,BottomSheetDelegate {
    
    
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var gMapView: GMSMapView!
    @IBOutlet weak var topTitleBackView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var containerViewYOpsition: NSLayoutConstraint!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var iPhoneUDIDString = String()
    var customerLatitude: String = ""
    var customerLongitude: String = ""
    var customerMarker = GMSMarker()
    var deliveryBoyMarker = GMSMarker()
    var storeMarker = GMSMarker()
    var mapCamera = GMSCameraPosition()
    var placesClient = GMSPlacesClient()
    var zoomLevel: Float = 16.0
    let geoCoder = CLGeocoder()
    var deliveryBoyLatitude: String = ""
    var deliveryBoyLongitude: String = ""
    var onceAllowedFlag : Bool = true
    
    var storeLatitude: String = ""
    var storeLongitude: String = ""
    var bounds = GMSCoordinateBounds()
    var allmarkers = Set<GMSMarker>()
    
    var order_id = String()
    var store_id = String()
    var navigationTypeStr = String()
    var orderTrackingDict = NSDictionary()
    var customerDetailsDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.layer.cornerRadius = 15
        container.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString
        print("iPhoneUDIDString UUID is : \(iPhoneUDIDString)")
        //mqttSetting()
        gMapView.layer.cornerRadius = 8.0
        self.gMapView.delegate = self
        self.gMapView.isMyLocationEnabled = true
        self.gMapView.settings.myLocationButton = false
        self.gMapView.moveCamera(.fit(.init(coordinate: .init(latitude: 36.72016, longitude: 4.42034), coordinate: .init(latitude: 36.72015, longitude: 4.42034))))
        orderTrackingApiCall()
        updateBottomSheet(status: "bottom")
        //        locationManager = CLLocationManager()
        //        locationManager.delegate = self
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //        locationManager.requestAlwaysAuthorization()
        //        locationManager.startMonitoringSignificantLocationChanges()
        //        locationManager.startUpdatingLocation()
        //
        ////        print(locationManager.location?.coordinate.latitude as Any)
        ////        print(locationManager.location?.coordinate.longitude as Any)
        ////
        ////        if  let lat = locationManager.location?.coordinate.latitude,
        ////            let long = locationManager.location?.coordinate.longitude {
        ////            customerLatitude = String(lat)
        ////            customerLongitude = String(long)
        ////        }
        ////        else {
        ////
        ////        }
        //
        //        self.gMapView.delegate = self
        //        self.gMapView.isMyLocationEnabled = true
        //        self.gMapView.settings.myLocationButton = false
        //
        //        orderIdLbl.text = order_id
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BottomSheetViewController{
            vc.bottomSheetDelegate = self
            vc.parentView = container
            vc.customer_orderId = order_id
            vc.customer_storeId = store_id
        }
    }
    
    // MARK: Order Tracking API Call
    func orderTrackingApiCall() {
        let Parse = CommomParsing()
        Parse.TrackOrderStatus(lang: login_session.value(forKey: "Language") as? String ?? "es", order_id: order_id, store_id: store_id, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.orderTrackingDict = response.value(forKey: "data") as! NSDictionary
                self.customerDetailsDict = self.orderTrackingDict.value(forKey: "customer_details") as! NSDictionary
                self.customerLatitude = self.customerDetailsDict.value(forKey: "cus_latitude") as? String ?? ""
                self.customerLongitude = self.customerDetailsDict.value(forKey: "cus_longitude") as? String ?? ""
                let addressString = self.customerDetailsDict.value(forKey: "cus:address") as? String ?? ""
                self.orderIdLbl.text = self.order_id
                if let restaurantDetails = self.orderTrackingDict.value(forKey: "restaurant_details") as? NSDictionary,
                   let restLatitude = Double(restaurantDetails.object(forKey: "restaurant_latitude") as? String ?? "") as? NSNumber,
                   let restLongitude = Double(restaurantDetails.object(forKey: "restaurant_longitude") as? String ?? "") as? NSNumber {
                    self.storeLatitude = restLatitude.stringValue
                    self.storeLongitude = restLongitude.stringValue
                    self.storeMarker = .init(position: .init(latitude: restLatitude.doubleValue, longitude: restLongitude.doubleValue))
                }
                
                
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    func updateBottomSheet(status : String) {
        if status == "top"{
            containerViewYOpsition.constant = 120
        }else if status == "bottom"{
            let tempFrame = UIScreen.main.bounds
            containerViewYOpsition.constant = tempFrame.size.height - 200
        }
    }
    func sendLatLang(deliverylatitude: String, deliverylongitude: String, storelatitude: String, storelongitude: String, customerlatitude: String, customerlongitude: String, customerAddressString:String) {
        guard let storeLatDouble = Double(storelatitude),
              let storeLongDouble = Double(storelongitude) else {
            return
        }
        let storeMarkerPosition = CLLocationCoordinate2DMake(storeLatDouble, storeLongDouble)
        if let dellat = Double(deliverylatitude),
           let dellon = Double(deliverylongitude) {
            let deliveryMarkerPosition = CLLocationCoordinate2DMake(dellat, dellon)
            CATransaction.begin()
            CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
            self.mapCamera = GMSCameraPosition.camera(withLatitude: dellat, longitude: dellon, zoom: self.zoomLevel)
            CATransaction.commit()
            self.deliveryBoyMarker = GMSMarker(position: deliveryMarkerPosition)
            self.deliveryBoyMarker.icon = self.imageWithImage(image: UIImage(named: "ic_vehicle")!, scaledToSize: CGSize(width: 30.0, height:30.0))
            deliveryBoyMarker.title = "DeliveryBoy Location"
            deliveryBoyMarker.snippet = ""
            self.deliveryBoyMarker.map = self.gMapView
            allmarkers.insert(deliveryBoyMarker)
        } else {
            self.mapCamera = GMSCameraPosition.camera(withLatitude: storeLatDouble, longitude: storeLongDouble, zoom: self.zoomLevel)
        }
        
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        CATransaction.commit()
        self.storeMarker = GMSMarker(position: storeMarkerPosition)
        self.storeMarker.icon = self.imageWithImage(image: UIImage(named: "ic_pick")!, scaledToSize: CGSize(width: 30.0, height:30.0))
        storeMarker.title = "Store Location"
        storeMarker.snippet = ""
        self.storeMarker.map = self.gMapView
        allmarkers.insert(storeMarker)
        
        let customerLatDouble = Double(customerlatitude)
        let customerLongDouble = Double(customerlongitude)
        let customerMarkerPosition = CLLocationCoordinate2DMake(customerLatDouble!, customerLongDouble!)
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        CATransaction.commit()
        self.customerMarker = GMSMarker(position: customerMarkerPosition)
        self.customerMarker.icon = self.imageWithImage(image: UIImage(named: "ic_drop")!, scaledToSize: CGSize(width: 30.0, height:30.0))
        customerMarker.title = "My Location"
        customerMarker.snippet = customerAddressString
        self.customerMarker.map = self.gMapView
        
        self.storeLatitude = storelatitude
        self.storeLongitude = storelongitude
        allmarkers.insert(customerMarker)
        
        for marker in self.allmarkers {
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        if onceAllowedFlag {
            onceAllowedFlag = false
            gMapView.moveCamera(.fit(bounds, with: .init(top: 0, left: 0, bottom: 0, right: 0)))
            gMapView.animate(to: self.mapCamera)
        }
        
        if let deliveryLatDouble = Double(deliverylatitude),
           let deliveryLonDouble = Double(deliverylongitude) {
            self.getPolylineRoute(from: CLLocationCoordinate2D(latitude: deliveryLatDouble,
                                                               longitude: deliveryLonDouble),
                                                               to: CLLocationCoordinate2D(latitude: customerLatDouble!,
                                                                                          longitude: customerLongDouble!))
        }
        
        if deliverylatitude != "" && deliverylongitude != "" {
            let deliveryLocation = CLLocation(latitude: Double(deliverylatitude)!, longitude: Double(deliverylongitude)!)
            let customerLocation = CLLocation(latitude: customerLatDouble!, longitude: customerLongDouble!)
            _ = deliveryLocation.bearingDegreesTo(location: customerLocation)
        }
    }
    
    // Pass your source and destination coordinates in this method.
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        var wayPoints = ""
        wayPoints = wayPoints.count == 0 ? "\(storeLatitude),\(storeLongitude)" : "\(wayPoints)%7C\(storeLatitude),\(storeLongitude)"
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=driving&waypoints=\(wayPoints)&key=AIzaSyBg5e4lx9fS1voiwnPjJ8YkjISFt7-sbfU")!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]  {
                        let jsonDict = json as NSDictionary
                        if jsonDict.value(forKey: "status") as! String == "ZERO_RESULTS" {
                            
                        }
                        else {
                            if let routes = json["routes"] as? [Dictionary<String, AnyObject>] {
                                if routes.count != 0 {
                                    print("not nil")
                                    if (routes.count > 0) {
                                        let overview_polyline = routes[0] as NSDictionary
                                        let dictPolyline = overview_polyline["overview_polyline"] as? NSDictionary
                                        let points = dictPolyline?.object(forKey: "points") as? String
                                        
                                        let distance = routes[0]["legs"] as? [Dictionary<String, AnyObject>]
                                        print(distance?[0]["distance"]?["text"] as! String)
                                        print(distance?[0]["duration"]?["text"] as! String)
                                        let distanceStr:String = distance?[0]["distance"]?["text"] as! String
                                        let durationStr:String = distance?[0]["duration"]?["text"] as! String
                                        print("\(distanceStr) \(durationStr)")
                                        
                                        DispatchQueue.main.async {
                                            //Call this method to draw path on map
                                            self.deliveryBoyMarker.title = "DeliveryBoy Location!"
                                            self.deliveryBoyMarker.appearAnimation = GMSMarkerAnimation.pop
                                            self.deliveryBoyMarker.opacity = 0.85
                                            self.deliveryBoyMarker.snippet = durationStr
                                            self.gMapView.selectedMarker = self.deliveryBoyMarker
                                            self.deliveryBoyMarker.map = self.gMapView
                                            self.showPath(polyStr: points!)
                                        }
                                    }
                                    else {
                                        DispatchQueue.main.async {}
                                    }
                                }
                                else {
                                    print("nil")
                                }
                            }
                        }
                    }
                }catch{
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    func showPath(polyStr :String) {
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 1.0
        polyline.strokeColor = UIColor.black
        polyline.map = gMapView // Your map view
    }
    
    // MARK: CLLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            gMapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            print("User allowed us to access location")
            //do whatever init activities here.
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.startUpdatingLocation()
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        //        customerLatitude = "\(location.coordinate.latitude)"
        //        customerLongitude = "\(location.coordinate.longitude)"
        
        let customerLatDouble = Double(customerLatitude)
        let customerLongDouble = Double(customerLongitude)
        self.customerMarker.map = nil
        
        
        
        
        
        if customerLatDouble != nil{
            let customerMarkerPosition = CLLocationCoordinate2DMake(customerLatDouble!, customerLongDouble!)
            CATransaction.begin()
            CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
            self.mapCamera = GMSCameraPosition.camera(withLatitude: customerLatDouble!, longitude: customerLongDouble!, zoom: self.zoomLevel)
            self.gMapView.animate(to: self.mapCamera)
            CATransaction.commit()
            self.customerMarker = GMSMarker(position: customerMarkerPosition)
            self.customerMarker.icon = self.imageWithImage(image: UIImage(named: "ic_drop")!, scaledToSize: CGSize(width: 30.0, height:30.0))
            customerMarker.title = "My Location"
            customerMarker.snippet = ""
            self.customerMarker.map = self.gMapView
            self.locationManager.stopUpdatingLocation()
        }
        
        
        
    }
    
    // MARK: GMSMapview Delegate
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("Map Dragging")
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print(position)
        self.gMapView.isMyLocationEnabled = true
        //gMapView.selectedMarker = deliveryBoyMarker
        let mapChangePosition = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        let coordinate: CLLocationCoordinate2D? = mapChangePosition.coordinate
        print(coordinate!.latitude)
        print(coordinate!.longitude)
        customerLatitude = "\(coordinate!.latitude)"
        customerLongitude = "\(coordinate!.longitude)"
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.gMapView.isMyLocationEnabled = true
        //gMapView.selectedMarker = deliveryBoyMarker
        let locationMapChange = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        let coordinate: CLLocationCoordinate2D? = locationMapChange.coordinate
        customerLatitude = "\(coordinate!.latitude)"
        customerLongitude = "\(coordinate!.longitude)"
        
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("yes")
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker Tapped")
        //gMapView.selectedMarker = deliveryBoyMarker
        if marker == customerMarker {
            print("customerMarker Tapped")
            gMapView.selectedMarker = customerMarker
        }
        else if marker == storeMarker {
            print("storeMarker Tapped")
            gMapView.selectedMarker = storeMarker
        }
        else {
            gMapView.selectedMarker = deliveryBoyMarker
            print("deliveryBoyMarker Tapped")
        }
        return true
    }
    
    // MARK: imageWithImage for markers
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func backBtntapped(_ sender: Any) {
        globalmqtt.disconnect()
        if navigationTypeStr == "present"{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension CLLocation {
    
    
    func getRadiansFrom(degrees: Double ) -> Double {
        
        return degrees * .pi / 180
        
    }
    
    func getDegreesFrom(radians: Double) -> Double {
        
        return radians * 180 / .pi
        
    }
    
    
    func bearingRadianTo(location: CLLocation) -> Double {
        
        let lat1 = self.getRadiansFrom(degrees: self.coordinate.latitude)
        let lon1 = self.getRadiansFrom(degrees: self.coordinate.longitude)
        
        let lat2 = self.getRadiansFrom(degrees: location.coordinate.latitude)
        let lon2 = self.getRadiansFrom(degrees: location.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        var radiansBearing = atan2(y, x)
        
        if radiansBearing < 0.0 {
            
            radiansBearing += 2 * .pi
            
        }
        
        
        return radiansBearing
    }
    
    func bearingDegreesTo(location: CLLocation) -> Double {
        
        return self.getDegreesFrom(radians: self.bearingRadianTo(location: location))
        
    }
    
    
}
