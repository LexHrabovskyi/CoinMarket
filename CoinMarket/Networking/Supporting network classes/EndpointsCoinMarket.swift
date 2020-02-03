//
//  EndpointsCoinMarket.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation

enum EndpointsCoinMarket {
    
    case ticker
    
    var path: String {
        switch self {
        case .ticker:
            return "ticker"
        }
    }
    
}
