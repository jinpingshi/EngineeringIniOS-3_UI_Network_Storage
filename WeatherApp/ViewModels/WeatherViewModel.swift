//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var currentWeather: Weather?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    private let weatherService: WeatherServiceProtocol
    private let storageService: StorageService
    private let cacheService: CacheServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        weatherService: WeatherServiceProtocol? = nil,
        storageService: StorageService? = nil,
        cacheService: CacheServiceProtocol? = nil,
        coreDataService: CoreDataServiceProtocol? = nil
    ) {
        self.weatherService = weatherService ?? WeatherService.shared
        self.storageService = storageService ?? StorageService.shared
        self.cacheService = cacheService ?? CacheService.shared
        self.coreDataService = coreDataService ?? CoreDataService.shared
        
        self.storageService.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Fetch Weather
    func fetchWeather(for city: String) async {
        guard !city.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let weather = try await weatherService.fetchWeather(city: city)
            currentWeather = weather
            storageService.lastSearchedCity = city
            coreDataService.saveWeather(weather)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Favorites
    func toggleFavorite(for city: String) {
        if storageService.isFavorite(city) {
            storageService.removeFromFavorites(city)
        } else {
            storageService.addToFavorites(city)
        }
    }
    
    func isFavorite(_ city: String) -> Bool {
        storageService.isFavorite(city)
    }
    
    var favoriteCities: [String] {
        storageService.favoriteCities
    }
    
    // MARK: - Load Last Search
    func loadLastSearch() {
        if let lastCity = storageService.lastSearchedCity {
            searchText = lastCity
            Task {
                await fetchWeather(for: lastCity)
            }
        }
    }
}
