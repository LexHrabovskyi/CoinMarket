//
//  TabHomeView.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import SwiftUI

struct TabHomeView: View {
    
    @EnvironmentObject private var marketService: MarketService
    
    var body: some View {
        
        TabView {
            
            CoinListView(isFavoriteList: false)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("all")
            }
            
            CoinListView(isFavoriteList: true)
                .tabItem {
                    Image(systemName: "text.badge.star")
                    Text("favorite")
            }
            
            
        }
        
    }
}

struct TabHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TabHomeView()
    }
}
