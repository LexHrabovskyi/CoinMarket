//
//  FavoriteService.swift
//  CoinMarket
//
//  Created by Александр on 03.02.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

// TODO: maybe should not use force unwrapping in Realm?
final class FavoriteService: ObservableObject {
    
    static func getFavoriteList() -> [FavoriteCoin] {
        let realm = try! Realm()
        let favorites = realm.objects(FavoriteCoin.self)
        return Array(favorites)
    }
    
    static func toogleFavorite(for coin: Coin) {
        
        let realm = try! Realm()
        if let deletedFavorite = findFavorite(with: coin.id, in: realm) {
            removeFromFavorite(deletedFavorite, in: realm)
        } else {
            addToFavorite(coin: coin, in: realm)
        }
        
    }
    
    private static func findFavorite(with id: String, in realm: Realm) -> FavoriteCoin? {
           
           let foundObject = realm.objects(FavoriteCoin.self).filter("id = %@", id).first
           return foundObject
           
       }
    
    private static func addToFavorite(coin: Coin, in realm: Realm) {
        let newFavorite = FavoriteCoin()
        newFavorite.id = coin.id
        try! realm.write {
            realm.add(newFavorite)
        }
    }
    
    private static func removeFromFavorite(_ coin: FavoriteCoin, in realm: Realm) {
        
        guard let deletedFavorite = findFavorite(with: coin.id, in: realm) else { return }
        
        try! realm.write {
            realm.delete(deletedFavorite)
        }
    }
    
}
