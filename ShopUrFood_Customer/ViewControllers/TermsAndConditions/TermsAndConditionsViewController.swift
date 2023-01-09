//
//  TermsAndConditionsViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 02/04/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import WebKit


class TermsAndConditionsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var termsTable: UITableView!
    @IBOutlet weak var baseContentView: UIView!
    var resultDict = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLbl.text = LanguageDictonary.value(forKey: "termasconditions") as? String
//        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
//        baseContentView.layer.cornerRadius = 5.0
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        termsTable.layer.cornerRadius = 5.0
        
        self.showLoadingIndicator(senderVC: self)
        self.getHelpData()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    func getHelpData(){
        let Parse = CommomParsing()
        self.showLoadingIndicator(senderVC: self)
        Parse.TermsPageData(lang: login_session.value(forKey: "Language") as? String ?? "es", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.resultDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                self.loadHTMLStringImage()
               // self.termsTable.reloadData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else{
            }
            self.stopLoadingIndicator(senderVC: self)
            
        }, onFailure: {errorResponse in})
    }
    func loadHTMLStringImage() -> Void {
           let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
           self.baseContentView.addSubview(webView)
           let htmlString = (self.resultDict.object(forKey: "content")as! NSDictionary).object(forKey: "description")as! String
           webView.loadHTMLString(htmlString, baseURL: nil)
       }
    
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultDict.object(forKey: "content") != nil{
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpContentDataTBCell") as? HelpContentDataTBCell
        cell?.selectionStyle = .none
        let htmlStr = (self.resultDict.object(forKey: "content")as! NSDictionary).object(forKey: "description")as! String
        cell?.contentLbl.attributedText = htmlStr.htmlToAttributedString
        return cell!
    }

}

