//
//  WorkingHoursTableViewCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 01/04/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class WorkingHoursTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var leftGrayView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var hoursStackView: UIStackView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hoursStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    func setup(data: DailySchedule) {
        if data.isAvailable {
            contentView.backgroundColor = UIColor.clear
        } else {
            contentView.backgroundColor = WhiteTranspertantColor
        }
        statusLbl.text = data.availability
        
        dayLbl.text = String(data.day.prefix(3))
        setCornorShadowEffects(sender: baseView)
        for openingTime in data.openingTimes {
            let label = UILabel()
            label.numberOfLines = 1
            label.translatesAutoresizingMaskIntoConstraints = false
            label.attributedText = openingTime.openingRow()
            label.setContentHuggingPriority(.defaultLow, for: .vertical)
            hoursStackView.addArrangedSubview(label)
        }
    }
}

fileprivate extension OpeningTime {
    func openingRow() -> NSAttributedString {
        let mutableString = NSMutableAttributedString()
        let boldAttribute: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 18, weight: .bold),
        ]
        
        let normalAttribute: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        
        mutableString.append(.init(string: "\(Localization.value(for: "opening_from")): ", attributes: boldAttribute))
        mutableString.append(.init(string: "\(start)", attributes: normalAttribute))
        mutableString.append(.init(string: " \(Localization.value(for: "opening_to")): ", attributes: boldAttribute))
        mutableString.append(.init(string: "\(end)", attributes: normalAttribute))
        
        return mutableString
    }
}

func setCornorShadowEffects(sender: UIView) {
    sender.layer.shadowColor = UIColor.lightGray.cgColor
    sender.layer.shadowOffset = CGSize(width: 3, height: 3)
    sender.layer.shadowOpacity = 0.7
    sender.layer.shadowRadius = 4.0
}
