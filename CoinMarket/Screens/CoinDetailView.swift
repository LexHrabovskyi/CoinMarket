//
//  CoinDetailView.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import SwiftUI

struct CoinDetailView: View {
    
    @EnvironmentObject private var marketService: MarketService
    private var coin: Coin
    
    init(with coin: Coin) {
        self.coin = coin
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(coin.symbol)
                .bold()
                .font(.system(size: 30))
            
            Text(coin.name)
                .bold()
                .font(.system(size: 20))
            
            Text("USD price is: \(coin.priceUsd)")
            Text("BTC price is: \(coin.priceBtc)")
            
        }
        .navigationBarItems(trailing: NavTrailingUpdateButton())
        
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(with: Coin(id: "bitcoin", name: "Bitcoin", symbol: "BTC", priceUsd: "9377.00503109", priceBtc: "1.0"))
            .environmentObject(MarketService())
    }
}
