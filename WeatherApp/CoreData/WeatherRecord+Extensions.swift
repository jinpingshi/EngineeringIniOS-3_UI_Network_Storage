//
//  WeatherRecord+Extensions.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import Foundation
import CoreData

extension WeatherRecord {
    convenience init(context: NSManagedObjectContext, weather: Weather) {
        self.init(context: context)
        self.id = weather.id
        self.city = weather.city
        self.temperature = weather.temperature
        self.feelsLike = weather.feelsLike
        self.weatherDescription = weather.description
        self.icon = weather.icon
        self.humidity = Int16(weather.humidity)
        self.timestamp = weather.timestamp
    }
    
    func toWeather() -> Weather? {
        guard let id = id,
              let city = city,
              let description = weatherDescription,
              let icon = icon,
              let timestamp = timestamp else {
            return nil
        }
        
        return Weather(
            id: id,
            city: city,
            temperature: temperature,
            feelsLike: feelsLike,
            description: description,
            icon: icon,
            humidity: Int(humidity),
            timestamp: timestamp
        )
    }
    
    // MARK: - Custom Fetch Requests
    static func fetchRequestAll(limit: Int = 50) -> NSFetchRequest<WeatherRecord> {
        let request = WeatherRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WeatherRecord.timestamp, ascending: false)]
        request.fetchLimit = limit
        return request
    }
    
    static func fetchRequestForCity(_ city: String) -> NSFetchRequest<WeatherRecord> {
        let request = WeatherRecord.fetchRequest()
        request.predicate = NSPredicate(format: "city == %@", city)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WeatherRecord.timestamp, ascending: false)]
        return request
    }
}
