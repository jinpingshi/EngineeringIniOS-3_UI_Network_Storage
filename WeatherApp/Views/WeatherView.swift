//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.isLoading {
                            LoadingView()
                                .frame(height: 300)
                        } else if let weather = viewModel.currentWeather {
                            weatherCard(for: weather)
                        } else if viewModel.errorMessage == nil {
                            emptyStateView
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Weather")
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        }
        .onAppear {
            viewModel.loadLastSearch()
        }
    }
    
    // MARK: - Weather Card
    private func weatherCard(for weather: Weather) -> some View {
        WeatherCard(
            weather: weather,
            isFavorite: viewModel.isFavorite(weather.city),
            onFavoriteToggle: {
                viewModel.toggleFavorite(for: weather.city)
            }
        )
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Enter city name", text: $viewModel.searchText)
                    .focused($isSearchFieldFocused)
                    .textFieldStyle(.plain)
                    .autocapitalization(.words)
                    .submitLabel(.search)
                    .onSubmit {
                        performSearch()
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    performSearch()
                }) {
                    Text("Search")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Search for a City")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Enter a city name to get current weather information")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(height: 300)
    }
    
    // MARK: - Perform Search
    private func performSearch() {
        isSearchFieldFocused = false
        Task {
            await viewModel.fetchWeather(for: viewModel.searchText)
        }
    }
}

#Preview {
    WeatherView()
}
