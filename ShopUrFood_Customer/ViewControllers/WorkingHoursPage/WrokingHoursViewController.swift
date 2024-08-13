//
//  WrokingHoursViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 01/04/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class WrokingHoursViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var navigationTitleLbl: UILabel!
    
    @IBOutlet weak var hoursTable: UITableView!
    @IBOutlet weak var baseContentView: UIView!
    var workingHours: WorkingHours?
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(workingHours != nil)
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "workinghours") as? String
        baseContentView.layer.cornerRadius = 5.0
        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        hoursTable.layer.cornerRadius = 5.0
        hoursTable.rowHeight = UITableView.automaticDimension
        hoursTable.estimatedRowHeight = 80
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView Delegate and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workingHours?.schedule.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkingHoursTableViewCell") as? WorkingHoursTableViewCell else {
            assert(false, "Did you forget to register this kind of Cell?")
            return .init()
        }
        cell.selectionStyle = .none
        guard let workingHours else {
            assert(false, "Not initialized correctly working hours")
            return .init()
        }
        
        let cellData = workingHours.schedule[indexPath.row]
        cell.setup(data: cellData)
        
        return cell
    }
}
