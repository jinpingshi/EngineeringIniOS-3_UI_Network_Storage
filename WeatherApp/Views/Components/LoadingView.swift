//
//  LoadingView.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    LoadingView()
}
