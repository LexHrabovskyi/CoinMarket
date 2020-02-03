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
    var errorLoadMessage = PassthroughSubject<String, Never>()
    
    func updateList() {
        
        NetworkManager.shared.getMarketData { (result: Result<CoinListData, APIError>) in
            
            switch result {
            case .success(let coinList):
                self.reloadList(with: coinList)
            case .failure(let error):
                self.handleLoadError(error)
            }
            
        }
        
    }
    
    func reloadList(with newList: CoinListData) {
        
        var newCoins = [Coin]()
        for coinData in newList {
            
            let convertedCoin = convertToCoin(coinData)
            guard let indexOfCoin = coinList.firstIndex(where: { $0.id == convertedCoin.id }) else {
                newCoins.append(convertedCoin)
                continue
            }
            
            guard coinNeedsToUpdate(lhs: coinList[indexOfCoin], rhs: convertedCoin) else { continue }
            
            DispatchQueue.main.async {
                self.coinList[indexOfCoin].priceBtc = convertedCoin.priceBtc
                self.coinList[indexOfCoin].priceUsd = convertedCoin.priceUsd
            }
            
        }
        
        DispatchQueue.main.async {
            self.coinList.append(contentsOf: newCoins)
        }
        
    }
    
    private func convertToCoin(_ coin: CoinData) -> Coin {
        return Coin(id: coin.id, name: coin.name, symbol: coin.symbol, priceUsd: coin.priceUsd, priceBtc: coin.priceBtc)
    }
    
    private func coinNeedsToUpdate(lhs: Coin, rhs: Coin) -> Bool {
        return lhs.priceBtc != rhs.priceBtc || lhs.priceUsd != rhs.priceUsd
    }
    
    private func handleLoadError(_ error: APIError) {
        
        DispatchQueue.main.async {
            if error == .notConnected {
                self.errorLoadMessage.send("Not connected to the internet!")
            } else {
                self.errorLoadMessage.send("Server problem. Please, try later")
            }
        }
        
    }
    
}
