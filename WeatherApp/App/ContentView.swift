//
//  ContentView.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        TabView {
            WeatherView()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun.fill")
                }
                .environmentObject(weatherViewModel)
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
                .environmentObject(weatherViewModel)
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
