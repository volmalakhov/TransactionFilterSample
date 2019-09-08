//
//  TransactionFilterSelectorView.swift
//  STASIS-Wallet
//
//  Created by Vladimir Malakhov on 17/01/2019.
//  Copyright © 2019 Strawberry Cake. All rights reserved.
//

import UIKit
import SnapKit

final class TransactionFilterSelectorView: TransactionFilterView {
    
    var onConfirm: DefaultCallback?
    var isHiddenCancelButton: ((Bool) -> ())?
    
    private var filters = Set<TransactionFilterGroup.Items>()
    private var typeStatus: TransactionFilterItem.Style = .disable
    private var currStatus: TransactionFilterItem.Style = .disable
        
    private let typeFilter: TransactionFilterCell = {
        let filter = TransactionFilterCell(.type)
        return filter
    }()
    
    private let currFilter: TransactionFilterCell = {
        let filter = TransactionFilterCell(.currency)
        return filter
    }()
    
    private let confirmButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.init(hexString: "009fe3")
        btn.setTitle(l10n("FILTER_APPLY_TITLE"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    override init() {
        super.init()
        setupView()
        subscriptForSelected()
        setupConfirmButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
// Public methods
//

extension TransactionFilterSelectorView {
    
    func selectItems(_ items: Set<TransactionFilterGroup.Items>, for group: TransactionFilterGroup) {
        switch group {
        case .type: typeFilter.select(items)
        case .currency: currFilter.select(items)
        }
    }
    
    func unselectItems() {
        typeFilter.unselect()
        currFilter.unselect()
    }
}

//
// Private methods
//

private extension TransactionFilterSelectorView {
    
    func setupView() {
        addSubviews()
        applyLayout()
    }
    
    func addSubviews() {
        addMultipleSubviews(with: [typeFilter, currFilter, confirmButton])
    }
    
    func applyLayout() {
        typeFilter.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        currFilter.snp.makeConstraints { (make) in
            make.top.equalTo(typeFilter.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}

private extension TransactionFilterSelectorView {
    
    func subscriptForSelected() {
        subscriptForSelectedFilters()
        subscriptForUpdateStatus()
    }
}

private extension TransactionFilterSelectorView {
    
    func subscriptForSelectedFilters() {
        typeFilter.onSelectedFilter = { [weak self] filter in
            self?.updateFilters(filter)
        }
        currFilter.onSelectedFilter = { [weak self] filter in
            self?.updateFilters(filter)
        }
    }
    
    func updateFilters(_ filter: TransactionFilterGroup.Items?) {
        guard let filter = filter else {
            return
        }
        if filters.contains(filter) {
            guard let index = filters.firstIndex(of: filter) else {
                return
            }
            filters.remove(at: index)
        } else {
            filters.insert(filter)
        }
    }
}

private extension TransactionFilterSelectorView {
    
    func subscriptForUpdateStatus() {
        typeFilter.onUpdateStatus = { [weak self] status in
            self?.typeStatus = status
            self?.updateConfirmButton()
        }
        currFilter.onUpdateStatus = { [weak self] status in
            self?.currStatus = status
            self?.updateConfirmButton()
        }
    }
    
    func updateConfirmButton() {
        if typeStatus == .enable || currStatus == .enable {
            confirmButton.isHidden = false
            isHiddenCancelButton?(false)
        } else {
            confirmButton.isHidden = true
            isHiddenCancelButton?(true)
        }
    }
}

private extension TransactionFilterSelectorView {
    
    func setupConfirmButton() {
        confirmButton.addTarget(self, action: #selector(onConfirmTapped), for: .touchUpInside)
    }
    
    @objc func onConfirmTapped() {
        AppState.sharedInstance.transactionFilters = filters
        onConfirm?()
    }
}
