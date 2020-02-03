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
    
    var body: some View {
        Button(action: {
            self.marketService.updateList()
        }) {
            Image(systemName: "arrow.clockwise")
        }
    }
}

struct NavTrailingUpdateButton_Previews: PreviewProvider {
    static var previews: some View {
        NavTrailingUpdateButton()
            .environmentObject(MarketService())
    }
}
