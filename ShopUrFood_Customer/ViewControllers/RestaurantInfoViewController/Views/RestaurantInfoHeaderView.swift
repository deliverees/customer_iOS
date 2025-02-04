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
    let restaurantStatus: String
    let minimumOrder: String
    let categories: [RestaurantInfoCategoryData]
}

protocol RestaurantInfoHeaderViewDelegate: AnyObject {
    func restaurantInfoHeaderView(_ view: RestaurantInfoHeaderView, didSelectCategory: RestaurantInfoCategoryData)
    func restaurantInfoHeaderView(_ view: RestaurantInfoHeaderView, didChangeSearchText: String?)
}

final class RestaurantInfoHeaderView: UIView {
    @IBOutlet weak var restaurantStatusLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var minimumOrderLabel: UILabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var categories: [RestaurantInfoCategoryData] = []
    
    weak var delegate: RestaurantInfoHeaderViewDelegate?
    private var contentView: UIView?
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        initialize()
    }
    
    private func loadFromNib() {
        let nibName = String(describing: RestaurantInfoHeaderView.self)
        guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else {
            fatalError("Could not load XIB for \(nibName)")
        }
        contentView = view
        contentView?.frame = bounds
        contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView!)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func initialize() {
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(SimpleLabelCell.self, forCellWithReuseIdentifier: "SimpleLabelCell")
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func setup(data: RestaurantInfoHeaderViewData) {
        deliveryTimeLabel.text = data.deliveryTime
        restaurantStatusLabel.text = data.restaurantStatus
        minimumOrderLabel.text = data.minimumOrder
        self.categories = data.categories
        categoriesCollectionView.reloadData()
        categoriesCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    @objc private func didChangeCategory(_ sender: UISegmentedControl) {
        let selectedCategoryIndex = sender.selectedSegmentIndex
        guard selectedCategoryIndex >= 0 && selectedCategoryIndex < categories.count else {
            return
        }
        let category = categories[selectedCategoryIndex]
        delegate?.restaurantInfoHeaderView(self, didSelectCategory: category)
    }
    
    func setCategoryData(result:NSMutableDictionary){
        guard let responseDict = result as? [AnyHashable : Any] else { return }
        var categories = [RestaurantInfoCategoryData(id: "0", name: "All")]
        
        for categoryDict in (responseDict["category_list"] as! [[String: Any]]) {
            let categoryName =  categoryDict["main_category_name"] as! String
            let categoryId = categoryDict["main_category_id"] as! NSNumber
            categories.append(RestaurantInfoCategoryData(id: categoryId.stringValue,
                                                         name: categoryName)
            )
        }
        let restaurantInfo = ((responseDict["restaurant_info"] as! NSDictionary))
        let deliveryTime = restaurantInfo.object(forKey: "delivery_time") as! String
        let restaurantStatus = restaurantInfo.object(forKey: "restaurant_status") as! String
        let currency = restaurantInfo.object(forKey: "restaurant_currency") as! String
        let price = (restaurantInfo.object(forKey: "minimum_order") as! NSNumber).stringValue
        let minimumPrice = currency + price
        let headerData = RestaurantInfoHeaderViewData(deliveryTime: deliveryTime,
                                                      restaurantStatus: restaurantStatus,
                                                      minimumOrder: minimumPrice,
                                                      categories: categories)
        setup(data: headerData)
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

extension RestaurantInfoHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleLabelCell", for: indexPath) as! SimpleLabelCell
        let category = categories[indexPath.row]
        cell.label.text = category.name
        cell.label.cornerRadius = 2 //15.0
        cell.label.layer.borderColor = AppDarkOrange.cgColor
        cell.label.layer.borderWidth = 0.5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        delegate?.restaurantInfoHeaderView(self, didSelectCategory: categories[indexPath.row])
    }
}

extension UIFont {
    static func truenoFont(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "TruenoSBd", size: size) else {
            fatalError("Failed to load the font TruenoSBd. Make sure it's added to the project and the Info.plist.")
        }
        return font
    }
}

extension UIImage {
    static func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

class SimpleLabelCell: UICollectionViewCell {
    class PaddingLabel: UILabel {
        var padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) // Puedes ajustar el padding aquí
        
        override func drawText(in rect: CGRect) {
            let paddedRect = rect.inset(by: padding)
            super.drawText(in: paddedRect)
        }
        
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let width = originalContentSize.width + padding.left + padding.right
            let height = originalContentSize.height + padding.top + padding.bottom
            return CGSize(width: width, height: height)
        }
    }
    let label: UILabel = {
        let lbl = PaddingLabel()
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.backgroundColor = AppLightOrange
                label.textColor = .white
            } else {
                label.backgroundColor = .white
                label.textColor = .darkText
            }
        }
    }
}
