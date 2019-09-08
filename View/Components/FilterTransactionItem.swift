//
//  FilterTransactionItem.swift
//  STASIS-Wallet
//
//  Created by Vladimir Malakhov on 17/01/2019.
//  Copyright © 2019 Strawberry Cake. All rights reserved.
//

import UIKit
import SnapKit

extension TransactionFilterItem {
    enum Style {
        case enable, disable
    }
    typealias UpdateStyleHandler = (TransactionFilterItem.Style) -> ()
}

final class TransactionFilterItem: UIButton {
    
    var isStyleMutable: Bool = true
    var onUpdateStyle : UpdateStyleHandler?
    var style: TransactionFilterItem.Style = .disable {
        didSet {
            guard isStyleMutable else { return }
            if style != oldValue {
                updateStyle()
                onUpdateStyle?(style)
            }
        }
    }
    var filter: TransactionFilterGroup.Items
    
    init(_ groupItem: TransactionFilterGroup.Items) {
        self.filter = groupItem
        super.init(frame: .zero)
        commonSetup()
        setupTitle(groupItem.title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        corner(radius: 16, corners: [.allCorners])
    }
}

private extension TransactionFilterItem {
    
    func setupTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
}

private extension TransactionFilterItem {
    
    func commonSetup() {
        setupLabel()
        setupStyle()
        addTarget()
    }
    
    func setupLabel() {
        titleLabel?.textAlignment = .left
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func setupStyle() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
}

private extension TransactionFilterItem {
    
    func addTarget() {
        addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    @objc func onTap() {
        style = style == .enable ? .disable : .enable
    }
    
    func updateStyle() {
        var bgColor: UIColor?
        switch style {
        case .disable:
            bgColor = UIColor.black.withAlphaComponent(0.5)
        case .enable:
            bgColor = UIColor.init(hexString: "009fe3")
        }
        backgroundColor = bgColor
    }
}
