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
                    NavigationLink(destination: CoinDetailView(with: coin)) {
                        CoinListRowView(coin: coin)
                    }
                }
            }
            .onAppear {
                self.updateList()
            }
            .navigationBarTitle("Coin market")
            .navigationBarItems(trailing: NavTrailingUpdateButton())
        }
        
    }
    
    private func updateList() {
        guard marketService.coinList.count == 0 else { return }
        marketService.updateList()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView()
            .environmentObject(MarketService())
    }
}
