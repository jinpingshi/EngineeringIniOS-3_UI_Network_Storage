//
//  Weather.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import Foundation

// MARK: - Weather Model
struct Weather: Identifiable, Codable, Sendable {
    let id: UUID
    let city: String
    let temperature: Double
    let feelsLike: Double
    let description: String
    let icon: String
    let humidity: Int
    let timestamp: Date
    
    init(
        id: UUID = UUID(),
        city: String,
        temperature: Double,
        feelsLike: Double,
        description: String,
        icon: String,
        humidity: Int,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.city = city
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.description = description
        self.icon = icon
        self.humidity = humidity
        self.timestamp = timestamp
    }
    
    // MARK: - From API Response
    init(from response: WeatherResponse) {
        self.id = UUID()
        self.city = response.name
        self.temperature = response.main.temp
        self.feelsLike = response.main.feelsLike
        self.description = response.weather.first?.description ?? ""
        self.icon = response.weather.first?.icon ?? ""
        self.humidity = response.main.humidity
        self.timestamp = Date()
    }
    
    // MARK: - Temperature String
    func temperatureString(unit: TemperatureUnit) -> String {
        let temp = unit.convert(from: temperature)
        return String(format: "%.0f%@", temp, unit.symbol)
    }
    
    func feelsLikeString(unit: TemperatureUnit) -> String {
        let temp = unit.convert(from: feelsLike)
        return String(format: "%.0f%@", temp, unit.symbol)
    }
}

// MARK: - Sample Data
extension Weather {
    static let sample = Weather(
        city: "London",
        temperature: 15.5,
        feelsLike: 14.2,
        description: "Partly cloudy",
        icon: "02d",
        humidity: 65
    )
    
    static let samples: [Weather] = [
        Weather(city: "London", temperature: 15.5, feelsLike: 14.2, description: "Partly cloudy", icon: "02d", humidity: 65),
        Weather(city: "Paris", temperature: 18.0, feelsLike: 17.5, description: "Clear sky", icon: "01d", humidity: 55),
        Weather(city: "Tokyo", temperature: 22.0, feelsLike: 21.0, description: "Rainy", icon: "10d", humidity: 80),
        Weather(city: "New York", temperature: 12.0, feelsLike: 10.5, description: "Cloudy", icon: "04d", humidity: 70)
    ]
}

// MARK: - API Response Models
struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherInfo]
    
    struct MainWeather: Codable {
        let temp: Double
        let feelsLike: Double
        let humidity: Int
    }
    
    struct WeatherInfo: Codable {
        let description: String
        let icon: String
    }
}
