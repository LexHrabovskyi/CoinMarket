//
//  MarketService.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//
import Foundation
import Combine

final class MarketService: ObservableObject {
    
    @Published var coinList: [Coin] = []
    
    func updateList() {
        
        NetworkManager.shared.getMarketData { (result: Result<CoinListData, APIError>) in
            
            switch result {
            case .success(let coinList):
                self.reloadList(with: coinList)
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    private func reloadList(with newList: CoinListData) {
        
        var newCoins = [Coin]()
        for coinData in newList {
            
            let convertedCoin = convertToCoin(coinData)
            guard let coinIndex = coinList.firstIndex(of: convertedCoin) else {
                newCoins.append(convertedCoin)
                continue
            }
            
            coinList[coinIndex].priceBtc = convertedCoin.priceBtc
            coinList[coinIndex].priceUsd = convertedCoin.priceUsd
            
        }
        
        DispatchQueue.main.async {
            self.coinList.append(contentsOf: newCoins)
        }
        
    }
    
    private func convertToCoin(_ coin: CoinData) -> Coin {
        return Coin(id: coin.id, name: coin.name, symbol: coin.symbol, priceUsd: String(coin.priceUsd ?? ""), priceBtc: String(coin.priceBtc ?? ""))
    }
    
    
}
