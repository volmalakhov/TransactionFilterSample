//
//  TransactionFilterGroup.swift
//  STASIS-Wallet
//
//  Created by Vladimir Malakhov on 17/01/2019.
//  Copyright © 2019 Strawberry Cake. All rights reserved.
//

import Foundation

enum TransactionFilterGroup {
    
    case type
    case currency
    
    var titleHeader: String {
        switch self {
        case .type:
            return l10n("FILTER_CATEGORY_TYPE")
        case .currency:
            return l10n("FILTER_CATEGORY_CURRENCY")
        }
    }
    
    var items: Set<TransactionFilterGroup.Items> {
        switch self {
        case .type:
            let i: Set<TransactionFilterGroup.Items> = [.received, .sent, .exchanged]
            return i
        case .currency:
            var i: Set<TransactionFilterGroup.Items> = [.eurs, .btc, .eth, .dai]
            let avaibleSelector = TickerSelector().avaible
            if avaibleSelector.contains(.PAX)  { i.insert(.pax)  }
            if avaibleSelector.contains(.TUSD) { i.insert(.tusd) }
            if avaibleSelector.contains(.USDC) { i.insert(.usdc) }
            return i
        }
    }
    
    enum Items {
        
        case received, sent, exchanged
        case eurs, btc, eth, dai, pax, usdc, tusd
        
        var title: String {
            switch self {
            case .received:
                return l10n("FILTER_TRX_TYPE_RECEIVED")
            case .sent:
                return l10n("FILTER_TRX_TYPE_SENT")
            case .exchanged:
                return l10n("FILTER_TRX_TYPE_EXCHANGED")
            case .eurs:
                return CryptoTicker.SET.description
            case .btc:
                return CryptoTicker.BTC.description
            case .eth:
                return CryptoTicker.ETH.description
            case .dai:
                return CryptoTicker.DAI.description
            case .pax:
                return CryptoTicker.PAX.description
            case .usdc:
                return CryptoTicker.USDC.description
            case .tusd:
                return CryptoTicker.TUSD.description
            }
        }
    }
}


