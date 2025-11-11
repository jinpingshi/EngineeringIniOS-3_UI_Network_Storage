//
//  Constants.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import Foundation

enum Constants {
    // MARK: - API
    enum API {
        static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        static let iconBaseURL = "https://openweathermap.org/img/wn/"
        static let apiKey = "16d85e71efc499d3ddc63fe89f1846e7"
    }
    
    // MARK: - UserDefaults Keys
    enum UserDefaultsKeys {
        static let favoriteCities = "favoriteCities"
        static let temperatureUnit = "temperatureUnit"
        static let lastSearchedCity = "lastSearchedCity"
    }
    
    // MARK: - Cache
    enum Cache {
        static let cacheDirectoryName = "WeatherIcons"
        static let maxCacheAge: TimeInterval = 7 * 24 * 60 * 60 // 7 days
    }
}

// MARK: - Temperature Unit
enum TemperatureUnit: String, Codable, CaseIterable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    
    var symbol: String {
        switch self {
        case .celsius:
            return "°C"
        case .fahrenheit:
            return "°F"
        }
    }
    
    func convert(from celsius: Double) -> Double {
        switch self {
        case .celsius:
            return celsius
        case .fahrenheit:
            return (celsius * 9/5) + 32
        }
    }
}
