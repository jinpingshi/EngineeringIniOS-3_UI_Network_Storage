//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var storageService = StorageService.shared
    @State private var cacheSize: Int64 = 0
    @State private var showClearCacheAlert = false
    @State private var showClearFavoritesAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // Temperature Unit Section
                Section {
                    Picker("Temperature Unit", selection: $storageService.temperatureUnit) {
                        ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Display")
                }
                
                // Cache Section
                Section {
                    HStack {
                        Text("Cache Size")
                        Spacer()
                        Text(cacheSize.formattedSize)
                            .foregroundColor(.secondary)
                    }
                    
                    Button(role: .destructive) {
                        showClearCacheAlert = true
                    } label: {
                        Text("Clear Cache")
                    }
                } header: {
                    Text("Cache")
                } footer: {
                    Text("Clearing cache will remove all downloaded weather icons")
                }
                
                // Favorites Section
                Section {
                    HStack {
                        Text("Favorite Cities")
                        Spacer()
                        Text("\(storageService.favoriteCities.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    if !storageService.favoriteCities.isEmpty {
                        Button(role: .destructive) {
                            showClearFavoritesAlert = true
                        } label: {
                            Text("Clear All Favorites")
                        }
                    }
                } header: {
                    Text("Favorites")
                }
                
                // About Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link("Weather Data by OpenWeather", destination: URL(string: "https://openweathermap.org")!)
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                updateCacheSize()
            }
            .alert("Clear Cache", isPresented: $showClearCacheAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    clearCache()
                }
            } message: {
                Text("Are you sure you want to clear all cached data?")
            }
            .alert("Clear Favorites", isPresented: $showClearFavoritesAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    storageService.clearFavorites()
                }
            } message: {
                Text("Are you sure you want to remove all favorite cities?")
            }
        }
    }
    
    // MARK: - Update Cache Size
    private func updateCacheSize() {
        cacheSize = CacheService.shared.cacheSize()
    }
    
    // MARK: - Clear Cache
    private func clearCache() {
        CacheService.shared.clearCache()
        updateCacheSize()
    }
}

#Preview {
    SettingsView()
}
