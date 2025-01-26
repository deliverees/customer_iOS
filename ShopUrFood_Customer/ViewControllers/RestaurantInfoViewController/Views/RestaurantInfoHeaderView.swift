//
//  RestaurantInfoHeaderView.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 26/1/25.
//  Copyright © 2025 apple4. All rights reserved.
//

import Foundation
import UIKit

struct RestaurantInfoCategoryData {
    let id: String
    let name: String
}
struct RestaurantInfoHeaderViewData {
    let deliveryTime: String
    let deliveryPrice: String
    let minimumOrder: String
    let categories: [RestaurantInfoCategoryData]
}

protocol RestaurantInfoHeaderViewDelegate: AnyObject {
    func restaurantInfoHeaderView(_ view: RestaurantInfoHeaderView, didSelectCategory: RestaurantInfoCategoryData)
    func restaurantInfoHeaderView(_ view: RestaurantInfoHeaderView, didChangeSearchText: String?)
}

@IBDesignable
final class RestaurantInfoHeaderView: UIView {
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var minimumOrderLabel: UILabel!
    @IBOutlet weak var categoriesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var categories: [RestaurantInfoCategoryData] = []
    
    weak var delegate: RestaurantInfoHeaderViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func loadFromNib() {
        guard let view = Bundle.main.loadNibNamed("RestaurantInfoHeaderView", owner: self, options: nil)?.first as? UIView else {
            fatalError("Could not load XIB for RestaurantInfoHeaderView")
        }
        view.frame = self.bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    private func initialize() {
        categoriesSegmentedControl.removeAllSegments()
        categoriesSegmentedControl.addTarget(self, action: #selector(didChangeCategory),
                                             for: .valueChanged)
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func setup(data: RestaurantInfoHeaderViewData) {
        deliveryTimeLabel.text = data.deliveryTime
        deliveryPriceLabel.text = data.deliveryPrice
        minimumOrderLabel.text = data.minimumOrder
        self.categories = data.categories
        data.categories.enumerated().forEach { index, category in
            categoriesSegmentedControl.insertSegment(withTitle: category.name,
                                                        at: index, animated: false)
        }
    }
    
    @objc private func didChangeCategory(_ sender: UISegmentedControl) {
        let selectedCategoryIndex = sender.selectedSegmentIndex
        guard selectedCategoryIndex >= 0 && selectedCategoryIndex < categories.count else {
            return
        }
        let category = categories[selectedCategoryIndex]
        delegate?.restaurantInfoHeaderView(self, didSelectCategory: category)
    }

}

extension RestaurantInfoHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.restaurantInfoHeaderView(self, didChangeSearchText: textField.text)
    }
}
