//
//  FilterTransctionCell.swift
//  STASIS-Wallet
//
//  Created by Vladimir Malakhov on 17/01/2019.
//  Copyright © 2019 Strawberry Cake. All rights reserved.
//

import UIKit
import SnapKit

extension TransactionFilterCell {
    typealias UpdateStatusHandler = ((TransactionFilterItem.Style) -> ())
    typealias SelectedFilterHandler = ((TransactionFilterGroup.Items?) -> ())
}

final class TransactionFilterCell: UIScrollView {
    
    var onUpdateStatus: UpdateStatusHandler?
    var onSelectedFilter: SelectedFilterHandler?
    var onCancelSelected: DefaultCallback?
    
    var isItemsStyleMutable: Bool
    
    private let btn = UIButton()
    private let contentView = UIView()
    private var filterItems = Set<TransactionFilterItem>()
    
    init(_ filterGroup: TransactionFilterGroup?, _ isItemsStyleMutable: Bool = true) {
        self.isItemsStyleMutable = isItemsStyleMutable
        super.init(frame: .zero)
        setupContentView()
        setupData(for: filterGroup)
    }
    
    convenience init(isItemsStyleMutable: Bool) {
        self.init(nil, isItemsStyleMutable)
        setupContentView()
        setupCancelButton(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
// Public methods
//

extension TransactionFilterCell {
    
    func append(_ items: Set<TransactionFilterGroup.Items>) {
        add(items)
    }
}

extension TransactionFilterCell {
    
    func select(_ items: Set<TransactionFilterGroup.Items>) {
        items.forEach { (groupItem) in isContainsItem(groupItem)?.style = .enable }
    }
    
    func unselect() {
        _ = filterItems.map{$0.style = .disable}
    }
}

//
// Private methods
//

private extension TransactionFilterCell {
    
    func setupContentView() {
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
}

private extension TransactionFilterCell {
    
    func setupData(for group: TransactionFilterGroup?) {
        guard let filterGroup = group else {
            STLog("TransactionFilterCell: Could not get filter group")
            return
        }
        setupHeaderLabel(for: filterGroup)
        setupFilterItems(for: filterGroup)
    }
}

private extension TransactionFilterCell {
    
    func setupHeaderLabel(for group: TransactionFilterGroup) {
        let label = makeLabel(group.titleHeader)
        add(label)
    }
    
    func makeLabel(_ title: String) -> UILabel {
        let header = UILabel(title)
        header.textAlignment = .left
        header.textColor = .white
        header.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return header
    }
    
    func add(_ label: UILabel) {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.right.equalToSuperview()
        }
    }
}

private extension TransactionFilterCell {
    
    func setupFilterItems(for group: TransactionFilterGroup) {
        add(group.items)
    }
    
    func make(_ groupItem: TransactionFilterGroup.Items) -> TransactionFilterItem {
        let item = TransactionFilterItem(groupItem)
        item.isStyleMutable = isItemsStyleMutable
        filterItems.insert(item)
        return item
    }
    
    func add(_ item: TransactionFilterItem, _ lastItem: TransactionFilterItem?, lastElement: Bool) {
        contentView.addSubview(item)
        let width = item.titleLabel?.sizeOfText().width ?? 40
        item.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(25)
            make.bottom.equalToSuperview()
            make.width.equalTo(width+20)
            if lastItem == nil {
                make.left.equalToSuperview().offset(20)
            } else {
                guard let leftOffset = lastItem?.snp.right else { return }
                make.left.equalTo(leftOffset).offset(10)
            }
            if lastElement {
                if subviews.contains(btn) {
                    make.right.equalTo(btn.snp.left).offset(-10)
                } else {
                    make.right.equalToSuperview().offset(-20)
                }
            }
        })
    }
    
    func sub(_ item: TransactionFilterItem) {
        item.onUpdateStyle = { style in
            self.onSelectedFilter?(item.filter)
            let enabledItems = self.filterItems.filter{$0.style == .enable}
            if enabledItems.count != 0 {
                self.onUpdateStatus?(.enable)
            } else {
                self.onUpdateStatus?(.disable)
            }
        }
    }
}

private extension TransactionFilterCell {
    
    func setupCancelButton(_ isNeeded: Bool) {
        guard isNeeded else {
            return
        }
        btn.setImage(#imageLiteral(resourceName: "dashboard_transaction_filter_cancel_icon"), for: .normal)
        addCancelButtonToView(btn)
        addTargerForCancelButton()
    }
    
    func addCancelButtonToView(_ button: UIButton) {
        addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
    }
    
    func addTargerForCancelButton() {
        btn.addTarget(self, action: #selector(onCancelTapped), for: .touchUpInside)
    }
    
    @objc func onCancelTapped() {
        onCancelSelected?()
    }
}

//
// Helper methods
//

private extension TransactionFilterCell {
    
    func isContainsItem(_ item: TransactionFilterGroup.Items) -> TransactionFilterItem? {
        return filterItems.first(where: {$0.filter == item})
    }
    
    func add(_ items: Set<TransactionFilterGroup.Items>) {
        var lastItemInCollection: TransactionFilterItem?
        for (index, element) in items.enumerated() {
            let item = make(element)
            add(item, lastItemInCollection, lastElement: index == items.count - 1)
            sub(item)
            lastItemInCollection = item
        }
    }
}
