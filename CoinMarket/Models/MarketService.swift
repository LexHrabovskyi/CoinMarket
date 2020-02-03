//
//  MarketService.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Combine

final class MarketService: ObservableObject {
    
    @Published var coinList: [Coin] = []
    
    func updateList() {
        
        // TODO: API
        coinList = [
            Coin(id: "bitcoin", name: "Bitcoin", symbol: "BTC", priceUsd: "9377.00503109", priceBtc: "1.0"),
            Coin(id: "ethereum", name: "Ethereum", symbol: "ETH", priceUsd: "190.548032792", priceBtc: "0.0203032")
        ]
        
    }
    
}
