//
//  CityRow.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import SwiftUI

struct CityRow: View {
    let cityName: String
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(cityName)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Button(action: onFavoriteToggle) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .gray)
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        CityRow(
            cityName: "London",
            isFavorite: true,
            onFavoriteToggle: {}
        )
        
        CityRow(
            cityName: "Paris",
            isFavorite: false,
            onFavoriteToggle: {}
        )
    }
}
