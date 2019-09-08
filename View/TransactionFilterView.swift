//
//  TransactionFilterView.swift
//  STASIS-Wallet
//
//  Created by Vladimir Malakhov on 17/01/2019.
//  Copyright © 2019 Strawberry Cake. All rights reserved.
//

import UIKit

extension TransactionFilterView {
    enum ViewType {
        case selector, display
    }
}

class TransactionFilterView: UIView {
        
    init() {
        super.init(frame: .zero)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TransactionFilterView {
    
    func commonSetup() {
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor.mainColor
    }
}
