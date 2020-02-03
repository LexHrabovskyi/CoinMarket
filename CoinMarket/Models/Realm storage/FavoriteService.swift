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
    
    static func addToFavorite(coin: Coin) {
        let realm = try! Realm()
        guard findFavorite(with: coin.id, in: realm) == nil else { return }
        let newFavorite = FavoriteCoin()
        newFavorite.id = coin.id
        try! realm.write {
            realm.add(newFavorite)
        }
    }
    
    static func removeFromFavorite(coin: Coin) {
        
        let realm = try! Realm()
        guard let deletedFavorite = findFavorite(with: coin.id, in: realm) else { return }
        
        try! realm.write {
            realm.delete(deletedFavorite)
        }
    }
    
    private static func findFavorite(with id: String, in realm: Realm) -> FavoriteCoin? {
        
        let foundObject = realm.objects(FavoriteCoin.self).filter("id = %@", id).first
        return foundObject
        
    }
    
}
