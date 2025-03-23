//
//  CartItemChoiceView.swift
//  ShopUrFood_Customer
//
//  Created by Aitor Pagán on 8/2/25.
//  Copyright © 2025 apple4. All rights reserved.
//

import UIKit

struct CartItemChoice {
    let name: String
    let price: Double
    let id: Int
    let type: CartItemChoiceType
    
    enum CartItemChoiceType {
        case one
        case two
        case three
    }
}

final class CartItemChoiceView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var choice: CartItemChoice? {
        didSet {
            nameLabel.text = choice?.name
        }
    }
    var onTap: (CartItemChoice) -> Void = { _ in }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .poppinsLight(size: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "large_orange_close"), for: .normal)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        button.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
        return button
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(removeButton)
        stack.axis = .horizontal
        return stack
    }()
    
    private func setup() {
        addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func didTapRemove() {
        guard let choice else { return }
        onTap(choice)
    }
}
