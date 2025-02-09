//
//  EditCartItemView.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 9/2/25.
//  Copyright © 2025 apple4. All rights reserved.
//

import UIKit

final class EditCartItemView: UIView {
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemPriceTitleLabel: UILabel!
    @IBOutlet weak var itemTaxLabel: UILabel!
    @IBOutlet weak var itemTaxTitleLabel: UILabel!
    @IBOutlet weak var itemSpecialInstructionsTextView: UITextField!
    @IBOutlet weak var itemSpecialInstructionsTitleLabel: UILabel!
    @IBOutlet weak var choicesTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var updateItemButton: UIButton!
    @IBOutlet weak var seeItemButton: UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    private var itemDetail: AddedItemDetail?
    private var selectedChoices: [SelectedCartChoice] = []
    
    var closeAction: (() -> Void)?
    var loadingAction: ((Bool) -> Void)?
    var errorAction: ((String?) -> Void)?
    var updateItemAction: (() -> Void)?
    var seeItemAction: (() -> Void)?
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    private func loadFromNib() {
        let nibName = String(describing: EditCartItemView.self)
        guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else {
            fatalError("Could not load XIB for \(nibName)")
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        itemPriceTitleLabel.text = Localization.value(for: "itemamount")
        itemSpecialInstructionsTitleLabel.text = Localization.value(for: "specialinstruction")
        updateItemButton.setTitle(Localization.value(for: "updatecart"), for: .normal)
        updateItemButton.titleLabel?.numberOfLines = 0
        seeItemButton.setTitle(Localization.value(for: "viewitem"), for: .normal)
        seeItemButton.titleLabel?.numberOfLines = 0
        updateItemButton.layer.cornerRadius = 8
        seeItemButton.layer.cornerRadius = 8
        choicesTableView.dataSource = self
        choicesTableView.delegate = self
        choicesTableView.register(UINib(nibName: "CartChoicesCell", bundle: nil), forCellReuseIdentifier: "CartChoicesCell")
        heightObserver = choicesTableView.observe(\.contentSize, options: [.new]) { [weak self] tableView, _ in
            self?.tableViewHeightConstraint.constant = tableView.contentSize.height
        }
        updateItemButton.addTarget(self, action: #selector(updateTap), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        seeItemButton.addTarget(self, action: #selector(seeItemTap), for: .touchUpInside)
    }
    
    private var heightObserver: NSKeyValueObservation?
    
    deinit {
        heightObserver?.invalidate()
        heightObserver = nil
    }
    
    func configure(itemDetail: AddedItemDetail) {
        self.itemDetail = itemDetail
        itemNameLabel.text = itemDetail.productName
        itemPriceLabel.text = itemDetail.cartCurrency + itemDetail.cartUnitPrice + " x" + "\(itemDetail.cartQuantity ?? 1)"
        if itemDetail.cartTax.isEmpty || itemDetail.cartTax == "0" {
            itemTaxTitleLabel.isHidden = true
            itemTaxLabel.isHidden = true
        } else {
            itemTaxLabel.text = itemDetail.cartCurrency + itemDetail.cartTax
        }
        itemSpecialInstructionsTextView.text = itemDetail.cartSplRequest
        choicesTableView.reloadData()
        if itemDetail.itemChoices.isEmpty {
            choicesTableView.isHidden = true
        }
        itemDetail.cartChoices.forEach { choice in
            selectedChoices.append(SelectedCartChoice(choiceId: choice.choiceId, choiceType: .one))
        }
        itemDetail.cartChoicesTwo.forEach { choice in
            selectedChoices.append(SelectedCartChoice(choiceId: choice.choiceId, choiceType: .two))
        }
        itemDetail.cartChoicesThree.forEach { choice in
            selectedChoices.append(SelectedCartChoice(choiceId: choice.choiceId, choiceType: .three))
        }
    }
    
    @objc private func updateTap() {
        loadingAction?(true)
        updateItem()
    }
    
    @objc private func seeItemTap() {
        seeItemAction?()
    }
    
    @objc private func closeTap() {
        closeAction?()
    }

    private func updateItem() {
        guard let itemDetail else {
            loadingAction?(false)
            return
        }
        let cartId = "\(itemDetail.cartId ?? -1)"
        let productId = "\(itemDetail.productId ?? -1)"
        let specialRequest = itemSpecialInstructionsTextView.text ?? ""
        var choiceId = [Int]()
        let selectedChoices: [Int] = selectedChoices.filter({ $0.choiceType == .one }).map(\.choiceId)
        
        let Parse = CommomParsing()
        Parse.updateCartWithChoice(lang: login_session.value(forKey: "Language") as? String ?? "es",
                                   cart_id: cartId,
                                   product_id: productId,
                                   choice_id: selectedChoices,
                                   special_request: specialRequest,
                                   onSuccess: { [weak self] response in
            self?.loadingAction?(false)
            if response.object(forKey: "code") as! Int == 200{
                self?.updateItemAction?()
            }else {
                self?.errorAction?(response.object(forKey: "message") as? String)
            }
        }, onFailure: { [weak self] errorResponse in
            self?.loadingAction?(false)
            self?.errorAction?(errorResponse?.localizedDescription)
        })
    }
    
    private struct SelectedCartChoice {
        let choiceId: Int
        let choiceType: ChoiceType
        
        enum ChoiceType {
            case one
            case two
            case three
        }
    }
}

extension EditCartItemView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemDetail?.itemChoices.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartChoicesCell", for: indexPath) as? CartChoicesCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        guard let choice = itemDetail?.itemChoices[indexPath.row] else {
            return UITableViewCell()
        }
        let nameStr = choice.choiceName
        cell.toppingNameLbl.text = nameStr
        let currency = choice.choiceCurrency
        let price = choice.choicePrice
        cell.toppingPriceLbl.text = "\(currency ?? "")\(price ?? "")"
        let selected = selectedChoices.contains(where: { $0.choiceId == choice.choiceId })
        let image = selected ? UIImage(named: "selectedCheckBox") : UIImage(named: "checkBox")
        cell.selectionImg.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let choice = itemDetail?.itemChoices.first else {
            return UITableViewCell()
        }
        let header = UIView()
        header.backgroundColor = UIColor.groupTableViewBackground
        let label = UILabel()
        label.text = "Toppings"
        label.textColor = UIColor.black
        label.font = UIFont.truenoRegular(size: 14)
        header.addSubview(label)
        header.frame = CGRect()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: header.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10),
            label.widthAnchor.constraint(equalToConstant: tableView.frame.width - 20)
        ])
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let choice = itemDetail?.itemChoices[indexPath.row] else {
            return
        }
        if selectedChoices.filter({ $0.choiceId == choice.choiceId }).contains(where: { $0.choiceId == choice.choiceId }) {
            selectedChoices.removeAll(where: { $0.choiceType == .one && $0.choiceId == choice.choiceId })
        } else {
            selectedChoices.append(SelectedCartChoice(choiceId: choice.choiceId, choiceType: .one))
        }
        tableView.reloadData()
    }
}
