//
//  APIErrors.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation

enum APIError: Error {
    case notConnected
    case invalidResponse
    case invalidEndpoint
    case noData
    case decodeError
    case apiError
}
