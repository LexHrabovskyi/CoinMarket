//
//  ContentView.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import SwiftUI

struct CoinListView: View {
    
    @EnvironmentObject private var marketService: MarketService
    
    var body: some View {
        NavigationView {
            List {
                ForEach(marketService.coinList) { coin in
                    Text(coin.name)
                }
            }
            .navigationBarTitle("Coin market")
            .navigationBarItems(trailing: Button(action: {
                self.marketService.updateList()
            }) {
                Image(systemName: "arrow.clockwise")
            })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView()
            .environmentObject(MarketService())
    }
}
