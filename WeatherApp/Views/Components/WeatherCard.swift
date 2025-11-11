//
//  WeatherCard.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import SwiftUI

struct WeatherCard: View {
    let weather: Weather
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    @State private var iconData: Data?
    @ObservedObject private var userDefaultsService = UserDefaultsService.shared
//    @AppStorage(Constants.UserDefaultsKeys.temperatureUnit) private var temperatureUnit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with city name and favorite button
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(weather.city)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(weather.timestamp.timeAgo())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                        .font(.title2)
                }
            }
            
            Divider()
            
            // Weather info
            HStack(spacing: 20) {
                // Weather icon
                if let iconData = iconData,
                   let uiImage = UIImage(data: iconData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 80, height: 80)
                } else {
                    Image(systemName: "cloud.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray.opacity(0.3))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(weather.temperatureString(unit: userDefaultsService.temperatureUnit))
                        .font(.system(size: 48, weight: .bold))
                    
                    Text(weather.description.capitalized)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Divider()
            
            // Additional info
            HStack(spacing: 30) {
                WeatherInfoItem(
                    icon: "thermometer",
                    title: "Feels Like",
                    value: weather.feelsLikeString(unit: userDefaultsService.temperatureUnit)
                )
                
                WeatherInfoItem(
                    icon: "humidity",
                    title: "Humidity",
                    value: "\(weather.humidity)%"
                )
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color.weatherColor(for: weather.icon).opacity(0.3),
                    Color.weatherColor(for: weather.icon).opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .task {
            await loadIcon()
        }
    }
    
    private func loadIcon() async {
        let cacheService = CacheService.shared
        let weatherService = WeatherService.shared
        
        if let cachedData = cacheService.loadImage(forKey: weather.icon) {
            iconData = cachedData
            return
        }
        
        do {
            let data = try await weatherService.fetchWeatherIcon(icon: weather.icon)
            iconData = data
            cacheService.saveImage(data, forKey: weather.icon)
        } catch {
            print("Failed to load icon: \(error)")
        }
    }
}

// MARK: - Weather Info Item
struct WeatherInfoItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
        }
    }
}

#Preview {
    WeatherCard(
        weather: Weather.sample,
        isFavorite: true,
        onFavoriteToggle: {}
    )
    .padding()
}
