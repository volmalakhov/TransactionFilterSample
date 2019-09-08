//
//  TransactionFilterViewLayer.swift
//  STASIS-Wallet
//
//  Created by Vladimir Malakhov on 17/01/2019.
//  Copyright © 2019 Strawberry Cake. All rights reserved.
//

import UIKit

final class TransactionFilterViewLayer: CommonViewLayer {
    
    private let filterView = TransactionFilterSelectorView()
    
    override func loadView() {
        super.loadView()
        view = filterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonSetup()
        setupAvaibleFilters()
        subscriptForEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cleanFiltersIfNeeded()
    }
}

private extension TransactionFilterViewLayer {
    
    func setupAvaibleFilters() {
        guard let filterItems = AppState.sharedInstance.transactionFilters else {
            return
        }
        var typeItems: Set<TransactionFilterGroup.Items>?
        var currItems: Set<TransactionFilterGroup.Items>?
        filterItems.forEach { (filterItem) in
            if TransactionFilterGroup.type.items.contains(filterItem) {
                if typeItems == nil {
                    typeItems = Set<TransactionFilterGroup.Items>()
                }
                typeItems?.insert(filterItem)
            }
            if TransactionFilterGroup.currency.items.contains(filterItem) {
                if currItems == nil {
                    currItems = Set<TransactionFilterGroup.Items>()
                }
                currItems?.insert(filterItem)
            }
        }
        if let typItems = typeItems {
            filterView.selectItems(typItems, for: .type)
        }
        if let curItems = currItems {
            filterView.selectItems(curItems, for: .currency)
        }
    }
    
    func cleanFiltersIfNeeded() {
        if let filters = AppState.sharedInstance.transactionFilters,
               filters.count == 0 {
            filterView.unselectItems()
        }
    }
}

private extension TransactionFilterViewLayer {
    
    func commonSetup() {
        setupBar()
        setupBarButtons()
    }
    
    func setupBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.mainColor
        navigationController?.navigationBar.isTranslucent = false
        title = l10n("FILTER_HEADER_TITLE")
    }
    
    func setupBarButtons() {
        filterView.isHiddenCancelButton = { [weak self] value in
            self?.navigationItem.rightBarButtonItem = value == true ? nil : UIBarButtonItem(image: #imageLiteral(resourceName: "dashboard_transaction_filter_cancel_icon"), style: .plain, target: self, action: #selector(self?.onCancelTapped))
        }
    }
}

private extension TransactionFilterViewLayer {
    
    func subscriptForEvents() {
        filterView.onConfirm = { [weak self] in
            self?.dismiss()
        }
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}

private extension TransactionFilterViewLayer {
    
    @objc func onCancelTapped() {
        cancelFiltersTransactions()
        unselectFiltersUI()
        dismiss()
    }
    
    func cancelFiltersTransactions() {
        AppState.sharedInstance.transactionFilters = nil
        let filterService = TransactionFilterService()
        filterService.cancel()
    }
    
    func unselectFiltersUI() {
        filterView.unselectItems()
    }
}
