//
//  StorageService.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import Foundation
import Combine

// MARK: - Storage Service Protocol
protocol StorageServiceProtocol: AnyObject {
    var favoriteCities: [String] { get set }
    var temperatureUnit: TemperatureUnit { get set }
    var lastSearchedCity: String? { get set }
    
    func addToFavorites(_ city: String)
    func removeFromFavorites(_ city: String)
    func isFavorite(_ city: String) -> Bool
    func clearFavorites()
}

// MARK: - Storage Service Implementation
final class StorageService: StorageServiceProtocol, ObservableObject {
    static let shared = StorageService()
    
    // MARK: - UserDefaults Properties
    @UserDefault(key: Constants.UserDefaultsKeys.favoriteCities, defaultValue: [])
    var favoriteCities: [String] {
        didSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault(key: Constants.UserDefaultsKeys.temperatureUnit, defaultValue: .celsius)
    var temperatureUnit: TemperatureUnit {
        didSet {
            print("🔥 Temperature unit changed to: \(temperatureUnit)")
            objectWillChange.send()
        }
    }
    
    @SimpleUserDefault(key: Constants.UserDefaultsKeys.lastSearchedCity, defaultValue: nil)
    var lastSearchedCity: String?
    
    private init() {}
    
    // MARK: - Favorite Cities Management
    func addToFavorites(_ city: String) {
        if !favoriteCities.contains(city) {
            favoriteCities.append(city)
        }
    }
    
    func removeFromFavorites(_ city: String) {
        favoriteCities.removeAll { $0 == city }
    }
    
    func isFavorite(_ city: String) -> Bool {
        favoriteCities.contains(city)
    }
    
    func clearFavorites() {
        favoriteCities.removeAll()
    }
}
