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
    @IBOutlet weak var subTitleLbl: UILabel!
    var ComingType = String()

   
    @IBOutlet weak var animationView: UIView!
    
    private var tempView: LottieAnimationView?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PermissionsManager.shared.requestAuthorizationAndNotificationsPermissions()
    }

    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func manualLocBtnAction(_ sender: Any) {
        AppRouter.shared.presentMapLocation(from: self) {
            self.dismiss(animated: true)
        }
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
