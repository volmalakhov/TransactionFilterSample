//
//  TransactionFilterDisplayView.swift
//  STASIS-Wallet
//
//  Created by Vladimir Malakhov on 17/01/2019.
//  Copyright © 2019 Strawberry Cake. All rights reserved.
//

import UIKit
import SnapKit

final class TransactionFilterDisplayView: TransactionFilterView {
    
    var onCancelFilter: DefaultCallback?
    
    func append(_ items: Set<TransactionFilterGroup.Items>) {
        clearSubviews()
        let cell = makeCell(items)
        add(cell)
        subscriptFor(cell)
    }
}

private extension TransactionFilterDisplayView {
    
    func makeCell(_ items: Set<TransactionFilterGroup.Items>) -> TransactionFilterCell {
        let cell = TransactionFilterCell(isItemsStyleMutable: false)
        cell.append(items)
        return cell
    }
    
    func subscriptFor(_ cell: TransactionFilterCell) {
        cell.onCancelSelected = {
            self.onCancelFilter?()
        }
    }
    
    func add(_ cell: TransactionFilterCell) {
        addSubview(cell)
        cell.snp.makeConstraints { (make) in
            make.top.left.right.bottom.width.equalToSuperview()
        }
    }
}

private extension TransactionFilterDisplayView {
    
    func clearSubviews() {
        _ = subviews.map{$0.removeFromSuperview()}
    }
}

