//
//  CoinListRowView.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import SwiftUI

struct CoinListRowView: View {
    
    var coin: Coin
    
    var body: some View {
        
        HStack {
            
            Text(coin.symbol)
                .bold()
            
            Spacer()
            
            Text(coin.priceUsd)
            
        }
        .padding()
        
    }
}

struct CoinListRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListRowView(coin: Coin(id: "bitcoin", name: "Bitcoin", symbol: "BTC", priceUsd: "9377.00503109", priceBtc: "1.0"))
    }
}
