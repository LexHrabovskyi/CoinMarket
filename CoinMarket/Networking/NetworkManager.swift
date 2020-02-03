//
//  NetworkManager.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation

// simplified network class
final class NetworkManager {
    
    public static let shared = NetworkManager()
    private let baseURL = URL(string: "https://api.coinmarketcap.com/v1")!
    private let urlSession = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    public func getMarketData(result: @escaping (Result<CoinListData, APIError>) -> Void) {
        
        let listURL = baseURL.appendingPathComponent(EndpointsCoinMarket.ticker.path)
        fetchResources(url: listURL, completion: result)
        
    }
    
    // MARK: underlaying functionality
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, APIError>) -> Void) {
        
        guard checkURL(url) else { completion(.failure(.invalidEndpoint)); return }
        
        urlSession.dataTask(with: url) { (result) in
            self.processResponce(result, completion: completion)
        }.resume()
        
    }
    
    private func checkURL(_ url: URL) -> Bool {
        
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
        
        guard let _ = urlComponents.url else {
            return false
        }
        
        return true
        
    }
    
    private func processResponce<T: Decodable>(_ result: (Result<(URLResponse, Data), Error>), completion: @escaping (Result<T, APIError>) -> Void) {
        
        switch result {
        case .success(let (response, data)):
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            do {
                let values = try self.jsonDecoder.decode(T.self, from: data)
                completion(.success(values))
            } catch {
                completion(.failure(.decodeError))
            }
        case .failure( _):
            completion(.failure(.apiError))
        }
        
    }
    
}

