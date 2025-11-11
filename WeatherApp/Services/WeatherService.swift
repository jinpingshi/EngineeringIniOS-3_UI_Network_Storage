//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import Foundation

// MARK: - Weather Service Error
enum WeatherServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case cityNotFound
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .cityNotFound:
            return "City not found. Please check the spelling."
        case .serverError(let code):
            return "Server error with code: \(code)"
        }
    }
}

// MARK: - Weather Service Protocol
protocol WeatherServiceProtocol: Sendable {
    func fetchWeather(city: String) async throws -> Weather
    func fetchWeatherIcon(icon: String) async throws -> Data
}

// MARK: - Weather Service Implementation
final class WeatherService: WeatherServiceProtocol, @unchecked Sendable {
    static let shared = WeatherService()
    
    private let baseURL = Constants.API.baseURL
    private let apiKey = Constants.API.apiKey
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        self.session = URLSession(configuration: configuration)
        
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Fetch Weather
    func fetchWeather(city: String) async throws -> Weather {
        guard var components = URLComponents(string: baseURL) else {
            throw WeatherServiceError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = components.url else {
            throw WeatherServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherServiceError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200:
                do {
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                    return Weather(from: weatherResponse)
                } catch {
                    throw WeatherServiceError.decodingError(error)
                }
            case 404:
                throw WeatherServiceError.cityNotFound
            default:
                throw WeatherServiceError.serverError(httpResponse.statusCode)
            }
        } catch let error as WeatherServiceError {
            throw error
        } catch {
            throw WeatherServiceError.networkError(error)
        }
    }
    
    // MARK: - Fetch Weather Icon
    func fetchWeatherIcon(icon: String) async throws -> Data {
        let iconURL = "\(Constants.API.iconBaseURL)\(icon)@2x.png"
        
        guard let url = URL(string: iconURL) else {
            throw WeatherServiceError.invalidURL
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            return data
        } catch {
            throw WeatherServiceError.networkError(error)
        }
    }
}
