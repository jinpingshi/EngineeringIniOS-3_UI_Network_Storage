//
//  Extensions.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import Foundation
import SwiftUI

// MARK: - Date Extensions
extension Date {
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = style
        return formatter.string(from: self)
    }
}

// MARK: - Color Extensions
extension Color {
    static func weatherColor(for icon: String) -> Color {
        switch icon {
        case let str where str.contains("01"): // Clear sky
            return .orange
        case let str where str.contains("02"): // Few clouds
            return .blue
        case let str where str.contains("03"), let str where str.contains("04"): // Clouds
            return .gray
        case let str where str.contains("09"), let str where str.contains("10"): // Rain
            return .blue
        case let str where str.contains("11"): // Thunderstorm
            return .purple
        case let str where str.contains("13"): // Snow
            return .cyan
        case let str where str.contains("50"): // Mist
            return .gray
        default:
            return .blue
        }
    }
}

// MARK: - Int64 Extensions
extension Int64 {
    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: self)
    }
}

// MARK: - String Extensions
extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValidCityName: Bool {
        !self.trimmed.isEmpty && self.trimmed.count >= 2
    }
}
