//
//  URLSessionExtention.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation

extension URLSession {
    
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        
        return dataTask(with: url) { [weak self] (data, response, error) in
            self?.dataTaskHandler(data, response, error, result)
        }
    }
    
    private func dataTaskHandler(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ result: @escaping (Result<(URLResponse, Data), Error>) -> Void) {
        
        if let error = error {
            result(.failure(error))
            return
        }
        
        guard let response = response, let data = data else {
            let error = NSError(domain: "error", code: 0, userInfo: nil)
            result(.failure(error))
            return
        }
        
        result(.success((response, data)))
        
    }
    
    
}
