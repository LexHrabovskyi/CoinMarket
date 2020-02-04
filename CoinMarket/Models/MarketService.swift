//
//  MarketService.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//
import Foundation
import Combine
import CoinMarketService

final class MarketService: ObservableObject {
    
    @Published var coinList: [Coin] = []
    var errorLoadMessage = PassthroughSubject<String, Never>()
    var didLoad = PassthroughSubject<Void, Never>()
    private var timer = Timer.publish(every: 60, on: .main, in: .default).autoconnect()
    private var oneMinuteUpdater: AnyCancellable? = nil
    
    init() {
        oneMinuteUpdater = timer.sink { _ in
            self.updateList()
        }
    }
    
    func updateList() {
        
        CoinMarketManager.shared.getMarketData { (result: Result<CoinListData, CoinAPIError>) in
            
            switch result {
            case .success(let coinList):
                self.reloadList(with: coinList)
            case .failure(let error):
                self.handleLoadError(error)
            }
            
            DispatchQueue.main.async {
                self.didLoad.send()
            }
            
        }
        
    }
    
    func toogleFavorite(for coin: Coin) {
        FavoriteService.toogleFavorite(for: coin)
        for index in coinList.indices {
            guard coin.id == coinList[index].id else { continue }
            DispatchQueue.main.async {
                self.coinList[index].isFavorite.toggle()
            }
            break
            
        }
    }
    
    // internal for testability
    func reloadList(with newList: CoinListData) {
        
        let favoriteList = FavoriteService.getFavoriteList()
        var newCoins = [Coin]()
        for coinData in newList {
            
            let isFavorite = favoriteList.first(where: { $0.id == coinData.id }) != nil
            let convertedCoin = convertToCoin(coinData, isFavorite: isFavorite)
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
    
    private func convertToCoin(_ coin: CoinData, isFavorite: Bool) -> Coin {
        return Coin(id: coin.id, name: coin.name, symbol: coin.symbol, priceUsd: coin.priceUsd, priceBtc: coin.priceBtc, isFavorite: isFavorite)
    }
    
    private func coinNeedsToUpdate(lhs: Coin, rhs: Coin) -> Bool {
        return lhs.priceBtc != rhs.priceBtc || lhs.priceUsd != rhs.priceUsd
    }
    
    private func handleLoadError(_ error: CoinAPIError) {
        
        DispatchQueue.main.async {
            if error == .notConnected {
                self.errorLoadMessage.send("Not connected to the internet!")
            } else {
                self.errorLoadMessage.send("Server problem. Please, try later")
            }
        }
        
    }
    
}
