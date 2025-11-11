//
//  HistoryView.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showClearAlert = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.history.isEmpty {
                    emptyStateView
                } else {
                    historyList
                }
            }
            .navigationTitle("History")
            .toolbar {
                if !viewModel.history.isEmpty {
                    Button(role: .destructive) {
                        showClearAlert = true
                    } label: {
                        Label("Clear All", systemImage: "trash")
                    }
                }
            }
            .alert("Clear History", isPresented: $showClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    viewModel.clearHistory()
                }
            } message: {
                Text("Are you sure you want to clear all search history?")
            }
        }
        .onAppear {
            viewModel.loadHistory()
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No History")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Your search history will appear here")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    // MARK: - History List
    private var historyList: some View {
        List {
            ForEach(viewModel.history) { weather in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(weather.city)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(weather.temperatureString(unit: .celsius))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text(weather.description.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(weather.timestamp.timeAgo())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .onDelete(perform: deleteHistory)
        }
        .listStyle(.insetGrouped)
    }
    
    // MARK: - Delete History
    private func deleteHistory(at offsets: IndexSet) {
        offsets.forEach { index in
            let weather = viewModel.history[index]
            viewModel.deleteHistory(weather: weather)
        }
    }
}

#Preview {
    HistoryView()
}
