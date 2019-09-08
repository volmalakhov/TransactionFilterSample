//
//  TransactionFilterService.swift
//  STASIS-Wallet
//
//  Created by Vladimir Malakhov on 21/01/2019.
//  Copyright © 2019 Strawberry Cake. All rights reserved.
//

import Foundation

final class TransactionFilterService {
    
    struct FilterParams {
        var ticker = [CryptoTicker]()
        var type = [TransactionType]()
    }
    
    var isUsedFlag = false
    
    func set(_ items: Set<TransactionFilterGroup.Items>) {
        var params = FilterParams(ticker: [CryptoTicker](), type: [TransactionType]())
        items.forEach { (item) in
            if let ticker = filterAdapterForTicker(item) {
                params.ticker.append(ticker)
            }
            if let type = filterAdapterForType(item) {
                params.type.append(type)
            }
        }
        guard let trModel = AppState.sharedInstance.walletInfo?.transactionsModel else {
            return
        }
        // to one struct
        if params.ticker.count == 0, params.type.count != 0  {
            trModel.filter(for: {params.type.contains($0.type)})
        } else if params.type.count == 0, params.ticker.count != 0 {
            trModel.filter(for: {params.ticker.contains($0.ticker)})
        } else if params.ticker.count != 0, params.type.count != 0 {
            trModel.filter(for: {params.ticker.contains($0.ticker) && params.type.contains($0.type)})
        }
    }
    
    func cancel() {
        guard let trModel = AppState.sharedInstance.walletInfo?.transactionsModel else {
            return
        }
        AppState.sharedInstance.transactionFilters = nil
        trModel.isFilter = false
    }
}

private extension TransactionFilterService {
    
    func filterAdapterForTicker(_ item: TransactionFilterGroup.Items) -> CryptoTicker? {
        switch item {
        case .btc:
            return .BTC
        case .eurs:
            return .SET
        case .eth:
            return .ETH
        case .dai:
            return .DAI
        case .pax:
            return .PAX
        case .tusd:
            return .TUSD
        case .usdc:
            return .USDC
        default:
            return nil
        }
    }
    
    func filterAdapterForType(_ item: TransactionFilterGroup.Items) -> TransactionType? {
        switch item {
        case .exchanged:
            return .exchange
        case .sent:
            return .sent
        case .received:
            return .received
        default:
            return nil
        }
    }
}
