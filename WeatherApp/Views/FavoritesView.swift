//
//  FavoritesView.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.favoriteCities.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
            }
            .navigationTitle("Favorites")
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Favorites Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add cities to your favorites to see them here")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    // MARK: - Favorites List
    private var favoritesList: some View {
        List {
            ForEach(viewModel.favoriteCities, id: \.self) { city in
                Button(action: {
                    Task {
                        await viewModel.fetchWeather(for: city)
                    }
                }) {
                    CityRow(
                        cityName: city,
                        isFavorite: true,
                        onFavoriteToggle: {
                            viewModel.toggleFavorite(for: city)
                        }
                    )
                }
            }
            .onDelete(perform: deleteFavorites)
        }
        .listStyle(.insetGrouped)
    }
    
    // MARK: - Delete Favorites
    private func deleteFavorites(at offsets: IndexSet) {
        offsets.forEach { index in
            let city = viewModel.favoriteCities[index]
            viewModel.toggleFavorite(for: city)
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(WeatherViewModel())
}
