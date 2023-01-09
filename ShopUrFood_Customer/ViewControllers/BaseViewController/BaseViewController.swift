//
//  BaseViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 07/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView
import JonAlert
import SCLAlertView




class BaseViewController: UIViewController {
   
    var  loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .circleStrokeSpin, color: AppDarkOrange, padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding the LoadingIndicator
    }
    
    func showLoadingIndicator(senderVC:UIViewController){
        let frame = CGRect(x: (self.view.frame.size.width-40)/2, y: (self.view.frame.size.height-40)/2, width: 40, height: 40)
        loadingIndicator.frame = frame
        senderVC.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        senderVC.view.isUserInteractionEnabled = false
    }
    
    func stopLoadingIndicator(senderVC:UIViewController){
        senderVC.view.isUserInteractionEnabled = true
        loadingIndicator.stopAnimating()
    }
    
    func showToastAlert(senderVC:UIViewController, messageStr:String)
    {
        senderVC.view.makeToast(messageStr, duration: 3.0)
        
    }
    
    func setCornorShadowEffects(sender:UIView) -> UIView {
        sender.layer.shadowColor = UIColor.lightGray.cgColor
        sender.layer.shadowOffset = CGSize(width: 3, height: 3)
        sender.layer.shadowOpacity = 0.7
        sender.layer.shadowRadius = 4.0
        return sender
    }
    func fourCornorShadow(sender:UIView) -> UIView{
        let shadowSize : CGFloat = 5.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: sender.frame.size.width + shadowSize,
                                                   height: sender.frame.size.height + shadowSize))
        sender.layer.masksToBounds = false
        sender.layer.shadowColor = UIColor.black.cgColor
        sender.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        sender.layer.shadowOpacity = 0.5
        sender.layer.shadowPath = shadowPath.cgPath
        return sender
    }
    
    func tokenExpired()
    {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.ManualLogoutOption()
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
   
    func showSuccessAlert(messageStr:String)
    {
         JonAlert.showSuccess(message: messageStr)
    }

    
    func showTokenExpiredPopUp(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
            kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
            showCloseButton: false,
            dynamicAnimatorActive: false,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Ok") {

        }
        
        let icon = UIImage(named:"warning")
        let color = AppLightOrange
        let warning = LanguageDictonary.object(forKey: "warning") as! String
        _ = alert.showCustom(warning, subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }
    

}
extension UIImageView {
    func circleImageView() {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}
