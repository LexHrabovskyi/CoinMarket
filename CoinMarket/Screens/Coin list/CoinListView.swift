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
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(marketService.coinList) { coin in
                    NavigationLink(destination: CoinDetailView(with: coin)) {
                        CoinListRowView(coin: coin)
                    }
                }
            }
            .navigationBarTitle("Coin market")
            .navigationBarItems(trailing: NavTrailingUpdateButton())
            .onAppear {
                self.updateList()
            }
            .onReceive(marketService.errorLoadMessage) { message in
                self.errorMessage = message
                self.showingError = true
            }
            .alert(isPresented: $showingError) {
                Alert(title: Text("Error"), message: Text(self.errorMessage), dismissButton: .default(Text("OK")))
            }
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
