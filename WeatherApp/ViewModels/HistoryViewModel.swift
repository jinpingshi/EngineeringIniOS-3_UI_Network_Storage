//
//  HistoryViewModel.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var history: [Weather] = []
    
    private let coreDataService: CoreDataServiceProtocol
    
    init(coreDataService: CoreDataServiceProtocol? = nil) {
        self.coreDataService = coreDataService ?? CoreDataService.shared
    }
    
    func loadHistory() {
        history = coreDataService.fetchHistory(limit: 50)
    }
    
    func deleteHistory(weather: Weather) {
        coreDataService.deleteHistory(weather: weather)
        loadHistory()
    }
    
    func clearHistory() {
        coreDataService.clearHistory()
        history = []
    }
}
