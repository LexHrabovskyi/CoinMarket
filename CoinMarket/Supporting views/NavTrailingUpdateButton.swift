//
//  NavTrailingUpdateButton.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import SwiftUI

struct NavTrailingUpdateButton: View {
    
    @EnvironmentObject private var marketService: MarketService
    @State private var isLoading = false
    
    var body: some View {
        
        ZStack {
            
            ActivityIndicator(isAnimating: $isLoading)
            
            Button(action: {
                self.marketService.updateList()
                self.isLoading = true
            }) {
                Image(systemName: "arrow.clockwise")
            }
            .opacity(isLoading ? 0 : 1)
            
        }
        .frame(width: 24, height: 24)
        .onReceive(marketService.didLoad) {
            self.isLoading = false
        }
        
        
    }
}

struct NavTrailingUpdateButton_Previews: PreviewProvider {
    static var previews: some View {
        NavTrailingUpdateButton()
            .environmentObject(MarketService())
    }
}
