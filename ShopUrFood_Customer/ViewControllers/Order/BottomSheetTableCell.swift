//
//  BottomSheetTableCell.swift
//  ShopUrFood_Customer
//
//  Created by apple5 on 25/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

struct TableCellViewModel {
    let image: UIImage?
    let title: String
    let subtitle: String
}

class BottomSheetTableCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var lineImageView: UIImageView!
    @IBOutlet weak var hideView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
