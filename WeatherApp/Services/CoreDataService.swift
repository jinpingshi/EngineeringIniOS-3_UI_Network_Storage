//
//  CoreDataService.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import Foundation
import CoreData

// MARK: - Core Data Service Protocol
protocol CoreDataServiceProtocol: AnyObject {
    func saveWeather(_ weather: Weather)
    func fetchHistory(limit: Int) -> [Weather]
    func fetchHistory(for city: String) -> [Weather]
    func deleteHistory(weather: Weather)
    func clearHistory()
}

// MARK: - Persistence Controller
final class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WeatherApp")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save Core Data context: \(error)")
            }
        }
    }
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        for weather in Weather.samples {
            _ = WeatherRecord(context: context, weather: weather)
        }
        
        controller.save()
        return controller
    }()
}

// MARK: - Core Data Service Implementation
final class CoreDataService: CoreDataServiceProtocol {
    static let shared = CoreDataService()
    
    private let persistenceController = PersistenceController.shared
    
    private var context: NSManagedObjectContext {
        persistenceController.context
    }
    
    private init() {}
    
    // MARK: - Save Weather
    func saveWeather(_ weather: Weather) {
        _ = WeatherRecord(context: context, weather: weather)
        persistenceController.save()
    }
    
    // MARK: - Fetch History
    func fetchHistory(limit: Int = 50) -> [Weather] {
        let fetchRequest = WeatherRecord.fetchRequestAll(limit: limit)
        
        do {
            let records = try context.fetch(fetchRequest)
            return records.compactMap { $0.toWeather() }
        } catch {
            print("Failed to fetch history: \(error)")
            return []
        }
    }
    
    // MARK: - Fetch History for City
    func fetchHistory(for city: String) -> [Weather] {
        let fetchRequest = WeatherRecord.fetchRequestForCity(city)
        
        do {
            let records = try context.fetch(fetchRequest)
            return records.compactMap { $0.toWeather() }
        } catch {
            print("Failed to fetch history for city: \(error)")
            return []
        }
    }
    
    // MARK: - Delete History
    func deleteHistory(weather: Weather) {
        let fetchRequest = WeatherRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", weather.id as CVarArg)
        
        do {
            let records = try context.fetch(fetchRequest)
            records.forEach { context.delete($0) }
            persistenceController.save()
        } catch {
            print("Failed to delete history: \(error)")
        }
    }
    
    // MARK: - Clear History
    func clearHistory() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = WeatherRecord.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            persistenceController.save()
        } catch {
            print("Failed to clear history: \(error)")
        }
    }
}
