//
//  Coin.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation

struct Coin: Identifiable {
    let id: String
    let name: String
    let symbol: String
    var priceUsd: String
    var priceBtc: String
    var isFavorite: Bool = false
}

extension Coin: Hashable {}

extension Coin: Codable {}
