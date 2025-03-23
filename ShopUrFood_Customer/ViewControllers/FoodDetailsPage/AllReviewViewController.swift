//
//  AllReviewViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 28/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class AllReviewViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var navigationTitleLbl: UILabel!
    
    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var baseContentView: UIView!
    var reviewArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        baseContentView.layer.cornerRadius = 5.0
        reviewTable.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "allreview") as? String
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllReviewsTableViewCell") as? AllReviewsTableViewCell
        cell?.selectionStyle = .none
        let userImgStr = (reviewArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_customer_profile")as! String
        if let imgURL = URL(string: userImgStr) {
            cell?.userImg.kf.setImage(with: .network(imgURL))
        }
        cell?.userNameLbl.text = ((reviewArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_customer_name")as! String)
        cell?.reviewMsgLbl.text = ((reviewArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_comments")as! String)
        
        if ((reviewArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! Int == 0 ){
            cell?.ratingStar.isHidden = false
            cell?.ratingCountLbl.isHidden = true
        }else{
            cell?.ratingStar.isHidden = true
            cell?.ratingCountLbl.isHidden = false
            cell?.ratingCountLbl.text = ((reviewArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! NSNumber).stringValue
        }
        cell!.baseView = self.setCornorShadowEffects(sender: cell!.baseView)

        return cell!
    }
    
}
