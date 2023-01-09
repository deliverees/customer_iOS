 //
 //  MapLocationPage.swift
 //  ShopUrFood_Customer
 //
 //  Created by apple4 on 13/02/19.
 //  Copyright © 2019 apple4. All rights reserved.
 //
 
 import UIKit
 import GoogleMaps
 import CoreLocation
 import GooglePlaces
 import Lottie
 import Alamofire
 
 
 
 class MapLocationPage: BaseViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var flatlandmark: UILabel!
    @IBOutlet weak var setDeliveryLocLbl: UILabel!
    @IBOutlet weak var locationStaticLbl: UILabel!
    @IBOutlet weak var SAVEANDPROCEEDBTN: UIButton!
    @IBOutlet weak var placeSearchView: UIView!
    @IBOutlet weak var placeTable: UITableView!
    @IBOutlet weak var bottomLocationView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var landMarkTxtField: UITextField!
    
    @IBOutlet weak var baseMapView: GMSMapView!
    var locationManager = CLLocationManager()
    var passLat = String()
    var passLong = String()
    var passAddress = String()
    var passZipCode = String()
    var addressString : String = ""
    
    @IBOutlet weak var animtationView: UIView!
    @IBOutlet weak var gifImageView: UIImageView!
    let placesClient = GMSPlacesClient.shared()
    
    @IBOutlet weak var currentLocationBtn: UIButton!
    
    @IBOutlet weak var search_closeBtn: UIButton!
    @IBOutlet weak var searchTxt: UITextField!
    var placeSearchArray = NSMutableArray()
    
    var autocompleteResults :[GApiResponse.Autocomplete] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTxt.placeholder = LanguageDictonary.object(forKey: "search") as? String
        self.locationStaticLbl.text = LanguageDictonary.object(forKey: "location") as? String
        self.SAVEANDPROCEEDBTN.setTitle(LanguageDictonary.object(forKey: "saveandproceed") as? String, for: .normal)
        self.setDeliveryLocLbl.text = LanguageDictonary.object(forKey: "setdeliverylocation") as? String
        self.flatlandmark.text = LanguageDictonary.object(forKey: "flatlandmark") as? String
        self.landMarkTxtField.placeholder = LanguageDictonary.object(forKey: "flatlandmark") as? String
        
        
        
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "googleMapStyle", withExtension: "json") {
                baseMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
        
        searchTxt.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
        
        searchView.layer.cornerRadius = 5.0
        searchView = self.setCornorShadowEffects(sender: searchView)
        baseMapView.delegate = self
        bottomLocationView.backgroundColor = .white
        currentLocationBtn.layer.cornerRadius = 25.0
        currentLocationBtn.clipsToBounds = true
        currentLocationBtn.backgroundColor = UIColor.white
        
        searchTxt.addTarget(self, action: #selector(typingName), for: .editingChanged)
        placeSearchView = self.setCornorShadowEffects(sender: placeSearchView)
        
        if login_session.object(forKey: "user_latitude") == nil{
            self.showTipsView()
        }
    }
    func showTipsView(){
        animtationView.isHidden = false
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        let lightBlackTranspertantColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
        let tempView = LOTAnimationView(name: "TapAnimation")
        tempView.frame = CGRect(x:((appDelegate?.window?.frame.size.width)! - 150)/2, y:((appDelegate?.window?.frame.size.height)! - 150)/2, width: 150, height: 150
        )
        animtationView.backgroundColor = lightBlackTranspertantColor
        animtationView.addSubview(tempView)
        
        tempView.play()
        tempView.loopAnimation = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        animtationView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        animtationView.isHidden = true
    }
    
    @IBAction func search_closeBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        searchTxt.text = ""
    }
    
    @IBAction func currentLocationBtnAction(_ sender: Any) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print(position)
        mapView.clear()
        let mapChangePosition = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        let coordinate: CLLocationCoordinate2D? = mapChangePosition.coordinate
        print(coordinate!.latitude)
        print(coordinate!.longitude)
        var input = GInput()
        let destination = GLocation.init(latitude: coordinate?.latitude, longitude: coordinate?.longitude)
        let position = CLLocationCoordinate2DMake(coordinate!.latitude,coordinate!.longitude)
        let marker = GMSMarker(position: position)
        marker.map = mapView
        marker.icon = GMSMarker.markerImage(with: AppLightOrange)
        marker.title = "Tap to select location"
        marker.appearAnimation = GMSMarkerAnimation.pop
        
        let center  = CLLocationCoordinate2D(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
        let MomentaryLatitude = center.latitude
        let MomentaryLongitude = center.longitude
        var coordinate2D = CLLocationCoordinate2D()
        coordinate2D.latitude = MomentaryLatitude
        coordinate2D.longitude = MomentaryLongitude
        
        let lat = String(coordinate2D.latitude)
        let lon = String(coordinate2D.longitude)
        
        self.addressString = ""
        input.destinationCoordinate = destination
        GoogleApi.shared.callApi(.reverseGeo , input: input) { (response) in
            if let places = response.data as? [GApiResponse.ReverseGio], response.isValidFor(.reverseGeo) {
                DispatchQueue.main.async {
                    self.addressString = places.first!.formattedAddress
                    print(self.addressString)
                    print(places.first?.placeId as Any)
                    self.addressLbl.text = self.addressString
                    self.passLat = lat
                    self.passLong = lon
                    self.passAddress = self.addressString
                    self.getAddressFromLatLong(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Tapped at coordinate: " + String(coordinate.latitude) + " "
            + String(coordinate.longitude))
        mapView.clear()
        /*
        let position = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.map = mapView
        marker.icon = GMSMarker.markerImage(with: AppLightOrange)
        marker.title = "Tap to select location"
        marker.appearAnimation = GMSMarkerAnimation.pop
        let lat = String(coordinate.latitude)
        let lon = String(coordinate.longitude)
        self.getAddressFromLatLon(pdblLatitude: lat, pdblLongitude: lon)
        */
        
        var input = GInput()
        let destination = GLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let position = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.map = mapView
        marker.icon = GMSMarker.markerImage(with: AppLightOrange)
        marker.title = "Tap to select location"
        marker.appearAnimation = GMSMarkerAnimation.pop
        let lat = String(coordinate.latitude)
        let lon = String(coordinate.longitude)
        self.addressString = ""
        input.destinationCoordinate = destination
        GoogleApi.shared.callApi(.reverseGeo , input: input) { (response) in
            if let places = response.data as? [GApiResponse.ReverseGio], response.isValidFor(.reverseGeo) {
                DispatchQueue.main.async {
                    self.addressString = places.first!.formattedAddress
                    print(self.addressString)
                    print(places.first?.placeId as Any)
                    self.addressLbl.text = self.addressString
                    self.passLat = lat
                    self.passLong = lon
                    self.passAddress = self.addressString
                    self.getAddressFromLatLong(latitude: coordinate.latitude, longitude: coordinate.longitude)
                }
            } else { print(response.error ?? "ERROR") }
        }
        
    }
    
    func getAddressFromLatLong(latitude: Double, longitude : Double) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyBg5e4lx9fS1voiwnPjJ8YkjISFt7-sbfU"

        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:

                let responseJson = response.result.value! as! NSDictionary

                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
                            let addressStr = results[0]["formatted_address"] as! String
                            print(addressStr)
                            for component in addressComponents {
                                if let temp = component.object(forKey: "types") as? [String] {
                                    if temp.count != 0 {
                                        if (temp[0] == "postal_code") {
                                            self.passZipCode = component["long_name"] as! String
                                            print(temp[0])
                                            print(self.passZipCode)
                                        }
                                        /*if (temp[0] == "locality") {
                                            self.city = component["long_name"] as? String
                                        }
                                        if (temp[0] == "administrative_area_level_1") {
                                            self.state = component["long_name"] as? String
                                        }
                                        if (temp[0] == "country") {
                                            self.country = component["long_name"] as? String
                                        }*/
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func typingName(textField:UITextField){
        if let typedText = textField.text {
            if typedText.count > 2 {
                showResults(string:typedText)
            }else{
                hideResults()
            }
            
            /*
            googlePlacesResult(input: typedText) { (result) -> Void in
                print(result)
            }*/
        }
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        _ = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 15.0)
        baseMapView.camera = camera
        baseMapView.isMyLocationEnabled = true
        locationManager.stopUpdatingLocation()
        let position = CLLocationCoordinate2DMake(userLocation!.coordinate.latitude,userLocation!.coordinate.longitude)
        baseMapView.clear()
        let marker = GMSMarker(position: position)
        marker.map = self.baseMapView
        marker.icon = GMSMarker.markerImage(with: AppLightOrange)
        marker.title = "Tap to select location"
        
        marker.appearAnimation = GMSMarkerAnimation.pop
        let lat = String(userLocation!.coordinate.latitude)
        let lon = String(userLocation!.coordinate.longitude)
        
        self.getAddressFromLatLon(pdblLatitude: lat, pdblLongitude: lon)
        
        var input = GInput()
        self.addressString = ""
        let destination = GLocation.init(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        input.destinationCoordinate = destination
        GoogleApi.shared.callApi(.reverseGeo , input: input) { (response) in
            if let places = response.data as? [GApiResponse.ReverseGio], response.isValidFor(.reverseGeo) {
                DispatchQueue.main.async {
                    self.addressString = places.first!.formattedAddress
                    print(self.addressString)
                    print(places.first?.placeId as Any)
                    self.addressLbl.text = self.addressString
                    self.passLat = lat
                    self.passLong = lon
                    self.passAddress = self.addressString
                    self.getAddressFromLatLong(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
    
    @IBAction func pickLocationBtnAction(_ sender: Any)
    {
        saveShippingAddress()
    }
    
    func saveShippingAddress()
    {
        if landMarkTxtField.text! == ""
        {
            self.showTokenExpiredPopUp(msgStr: LanguageDictonary.object(forKey: "locationpop") as! String)
            
        }
        else
        {
            if globalCartCount != 0
            {
                let messagefrom = LanguageDictonary.object(forKey: "messagefrom") as! String
                let refreshAlert = UIAlertController(title: "\(messagefrom) \(Appname)", message: LanguageDictonary.object(forKey: "mapcart") as! String, preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: LanguageDictonary.object(forKey: "yes") as! String, style: .default, handler: { (action: UIAlertAction!) in
                    
                    if self.passLat != "" {
                        if MapLocationPageFrom == "login"{
                            login_session.setValue(self.passLat, forKey: "user_latitude")
                            login_session.setValue(self.passLong, forKey: "user_longitude")
                            login_session.setValue(self.passAddress, forKey: "user_address")
                            login_session.synchronize()
                            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                            appDelegate?.checkRootView()
                        }else{
                            ActAsSelectedAddress = self.passAddress
                            ActAsSelectedLatitude = self.passLat
                            ActAsSelectedLongitude = self.passLong
                            ActAsSelectedZipCode = self.passZipCode
                            self.dismiss(animated: true, completion: nil)
                        }
                        self.saveFinalShippingAddress()
                    }
                    else
                    {
                        self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "validlocation") as! String )
                    }
                    
                }))
                refreshAlert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
                    refreshAlert .dismiss(animated: true, completion: nil)
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
            }
            else
            {
                if self.passLat != "" {
                    if MapLocationPageFrom == "login"{
                        login_session.setValue(self.passLat, forKey: "user_latitude")
                        login_session.setValue(self.passLong, forKey: "user_longitude")
                        login_session.setValue(self.passAddress, forKey: "user_address")
                        login_session.synchronize()
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.checkRootView()
                    }else{
                        ActAsSelectedAddress = self.passAddress
                        ActAsSelectedLatitude = self.passLat
                        ActAsSelectedLongitude = self.passLong
                        ActAsSelectedZipCode = self.passZipCode
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.saveFinalShippingAddress()
                }else{
                    self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "validlocation") as! String )
                }
            }
        }
    }
    
    func saveFinalShippingAddress()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.saveShippingAddress(lang: login_session.value(forKey: "Language") as? String ?? "es", search_latitude: passLat, search_longitude: passLong, zipcode: passZipCode, location: passAddress, address: landMarkTxtField.text!, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
                
            }
            else if response.object(forKey: "code")as! Int == 400
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
                print(response.object(forKey: "message") as Any)
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
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
        
        self.addressString = ""
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                self.addressString = ""
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
                    }
                    
                    
                    print(self.addressString)
                    self.addressLbl.text = self.addressString
                    self.passLat = pdblLatitude
                    if pm.postalCode != nil{
                        self.passZipCode = pm.postalCode!
                    }
                    self.passLong = pdblLongitude
                    self.passAddress = self.addressString
                }
        })
        
        
    }
    
    
    
    // MARK: TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideResults()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //MARK: - Google place API request -
    func googlePlacesResult(input: String, completion: @escaping (_ result: NSArray) -> Void) {
        
        let urlString = NSString(format: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&key=AIzaSyDI3KfTjweOu_rjMSgzZpV3kq_GCxwPLvI&sessiontoken=1234567890",input)
        print(urlString)
        let url = NSURL(string: urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
        
        //let url = URL(string: urlString as String)
        //print(url!)
        let defaultConfigObject = URLSessionConfiguration.default
        let delegateFreeSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
        let request = NSURLRequest(url: url! as URL)
        let task =  delegateFreeSession.dataTask(with: request as URLRequest, completionHandler:
        {
            (data, response, error) -> Void in
            if let data = data
            {
                do {
                    let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                    let results:NSArray = jSONresult["predictions"] as! NSArray
                    let status = jSONresult["status"] as! String
                    if status == "NOT_FOUND" || status == "REQUEST_DENIED"
                    {
                        //                            let userInfo:NSDictionary = ["error": jSONresult["status"]!]
                        //                            let newError = NSError(domain: "API Error", code: 666, userInfo: userInfo as [NSObject : AnyObject])
                        //                            let arr:NSArray = [newError]
                        //                            completion(arr)
                        return
                    }
                    else
                    {
                        self.placeSearchArray.removeAllObjects()
                        self.placeSearchArray.addObjects(from: results as! [NSDictionary])
                        if self.placeSearchArray.count == 0 {
                            self.placeSearchView.isHidden = true
                        }else{
                            self.placeSearchView.isHidden = false
                            self.placeTable.reloadData()
                        }
                        completion(results)
                    }
                }
                catch
                {
                    print("json error: \(error)")
                }
            }
            else if let error = error
            {
                print(error)
            }
        })
        task.resume()
    }
    
    func getLatitudeLogitude(place_id: String,completion: @escaping (_ result: NSDictionary) -> Void) {
        
        let urlString = NSString(format: "https://maps.googleapis.com/maps/api/place/details/json?input=&placeid=%@&key=AIzaSyDI3KfTjweOu_rjMSgzZpV3kq_GCxwPLvI",place_id)
        print(urlString)
        //let url = NSURL(string: urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
        let url = URL(string: urlString as String)
        print(url!)
        let defaultConfigObject = URLSessionConfiguration.default
        let delegateFreeSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
        let request = NSURLRequest(url: url! as URL)
        let task =  delegateFreeSession.dataTask(with: request as URLRequest, completionHandler:
        {
            (data, response, error) -> Void in
            if let data = data
            {
                do {
                    let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                    let resultsDict:NSDictionary = jSONresult["result"] as! NSDictionary
                    let geometryDict:NSDictionary = resultsDict["geometry"]as! NSDictionary
                    let locationDict:NSDictionary = geometryDict["location"]as! NSDictionary
                    let status = jSONresult["status"] as! String
                    if status == "NOT_FOUND" || status == "REQUEST_DENIED"
                    {
                        //                            let userInfo:NSDictionary = ["error": jSONresult["status"]!]
                        //                            let newError = NSError(domain: "API Error", code: 666, userInfo: userInfo as [NSObject : AnyObject])
                        //                            let arr:NSArray = [newError]
                        //                            completion(arr)
                        return
                    }
                    else
                    {
                        completion(locationDict)
                    }
                }
                catch
                {
                    print("json error: \(error)")
                }
            }
            else if let error = error
            {
                print(error)
            }
        })
        task.resume()
    }
    
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeSearchArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListTBCell") as? LocationListTBCell
        cell?.selectionStyle = .none
        let tempDict = NSMutableDictionary()
        tempDict.addEntries(from: (placeSearchArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
        cell?.locationNameLbl.text = (tempDict.object(forKey: "description") as! String)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        placeSearchView.isHidden = true
        var placeId = String()
        let tempDict = NSMutableDictionary()
        tempDict.addEntries(from: (placeSearchArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
        searchTxt.text = (tempDict.object(forKey: "description") as! String)
        placeId = tempDict.object(forKey: "place_id")as! String
        self.getLatitudeLogitude(place_id: placeId){ (result) -> Void in
            print(result)
            self.baseMapView.clear()
            let MomentaryLatitude = result.object(forKey: "lat")as! Double
            let MomentaryLongitude = result.object(forKey: "lng")as! Double
            var coordinate = CLLocationCoordinate2D()
            coordinate.latitude = MomentaryLatitude
            coordinate.longitude = MomentaryLongitude
            let position = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
            let marker = GMSMarker(position: position)
            marker.map = self.baseMapView
            marker.icon = GMSMarker.markerImage(with: AppLightOrange)
            marker.title = "Tap to select location"
            
            marker.appearAnimation = GMSMarkerAnimation.pop
            let lat = String(coordinate.latitude)
            let lon = String(coordinate.longitude)
            self.getAddressFromLatLon(pdblLatitude: lat, pdblLongitude: lon)
            let camera = GMSCameraPosition.camera(withLatitude: MomentaryLatitude, longitude: MomentaryLongitude, zoom: 16)
            self.baseMapView?.camera = camera
            self.baseMapView?.animate(to: camera)
        }
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListTBCell") as? LocationListTBCell
        cell?.selectionStyle = .none
        cell?.locationNameLbl.text = autocompleteResults[indexPath.row].formattedAddress
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTxt.text = autocompleteResults[indexPath.row].formattedAddress
        searchTxt.resignFirstResponder()
        self.view.endEditing(true)
        placeSearchView.isHidden = true
        var placeID:String = autocompleteResults[indexPath.row].placeId
        var input = GInput()
        input.keyword = autocompleteResults[indexPath.row].placeId
        GoogleApi.shared.callApi(.placeInformation,input: input) { (response) in
            if let place =  response.data as? GApiResponse.PlaceInfo, response.isValidFor(.placeInformation) {
                DispatchQueue.main.async {
                    placeID = place.placeId
                    print(placeID)
                    if let lat = place.latitude, let lng = place.longitude{
                        let center  = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        print(center.latitude)
                        print(center.longitude)
                        self.baseMapView.clear()
                        
                        CATransaction.begin()
                        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
                        CATransaction.commit()
                        
                        let marker = GMSMarker(position: center)
                        marker.map = self.baseMapView
                        marker.icon = GMSMarker.markerImage(with: AppLightOrange)
                        marker.title = "Tap to select location"
                        marker.appearAnimation = GMSMarkerAnimation.pop
                        
                        let MomentaryLatitude = center.latitude
                        let MomentaryLongitude = center.longitude
                        var coordinate = CLLocationCoordinate2D()
                        coordinate.latitude = MomentaryLatitude
                        coordinate.longitude = MomentaryLongitude
                        
                        //let lat = String(coordinate.latitude)
                        //let lon = String(coordinate.longitude)
                        //self.getAddressFromLatLon(pdblLatitude: lat, pdblLongitude: lon)
                        let camera = GMSCameraPosition.camera(withLatitude: MomentaryLatitude, longitude: MomentaryLongitude, zoom: 16)
                        self.baseMapView?.camera = camera
                        self.baseMapView?.animate(to: camera)
                    }
                    self.placeTable.reloadData()
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
    
    func showResults(string:String){
        var input = GInput()
        input.keyword = string
        GoogleApi.shared.callApi(input: input) { (response) in
            if response.isValidFor(.autocomplete) {
                DispatchQueue.main.async {
                    self.searchView.isHidden = false
                    self.autocompleteResults = response.data as! [GApiResponse.Autocomplete]
                    
                    //self.placeSearchArray.removeAllObjects()
                    //self.placeSearchArray.addObjects(from: self.autocompleteResults as! [NSDictionary])
                    if self.autocompleteResults.count == 0 {
                        self.placeSearchView.isHidden = true
                    }else{
                        self.placeSearchView.isHidden = false
                        self.placeTable.reloadData()
                    }
                    //self.placeTable.reloadData()
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
    func hideResults(){
        placeSearchView.isHidden = true
        autocompleteResults.removeAll()
        placeTable.reloadData()
    }
    
    
    
 }
