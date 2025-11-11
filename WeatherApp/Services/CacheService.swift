//
//  CacheService.swift
//  WeatherApp
//
//  Created by Jinping Shi on 2025/11/11.
//

import Foundation
import UIKit

// MARK: - Cache Service Protocol
protocol CacheServiceProtocol: Sendable {
    func saveImage(_ data: Data, forKey key: String)
    func loadImage(forKey key: String) -> Data?
    func removeImage(forKey key: String)
    func clearCache()
    func cacheSize() -> Int64
}

// MARK: - Cache Service Implementation
final class CacheService: CacheServiceProtocol, @unchecked Sendable {
    static let shared = CacheService()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let cachesURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesURL.appendingPathComponent(Constants.Cache.cacheDirectoryName)
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
        
        cleanOldCache()
    }
    
    // MARK: - Save Image
    func saveImage(_ data: Data, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? data.write(to: fileURL)
    }
    
    // MARK: - Load Image
    func loadImage(forKey key: String) -> Data? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        if let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
           let modificationDate = attributes[.modificationDate] as? Date {
            let age = Date().timeIntervalSince(modificationDate)
            if age > Constants.Cache.maxCacheAge {
                try? fileManager.removeItem(at: fileURL)
                return nil
            }
        }
        
        return try? Data(contentsOf: fileURL)
    }
    
    // MARK: - Remove Image
    func removeImage(forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: fileURL)
    }
    
    // MARK: - Clear Cache
    func clearCache() {
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil) else {
            return
        }
        
        for file in files {
            try? fileManager.removeItem(at: file)
        }
    }
    
    // MARK: - Cache Size
    func cacheSize() -> Int64 {
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }
        
        var totalSize: Int64 = 0
        for file in files {
            if let attributes = try? fileManager.attributesOfItem(atPath: file.path),
               let size = attributes[.size] as? Int64 {
                totalSize += size
            }
        }
        
        return totalSize
    }
    
    // MARK: - Clean Old Cache
    private func cleanOldCache() {
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.contentModificationDateKey]) else {
            return
        }
        
        let now = Date()
        for file in files {
            if let attributes = try? fileManager.attributesOfItem(atPath: file.path),
               let modificationDate = attributes[.modificationDate] as? Date {
                let age = now.timeIntervalSince(modificationDate)
                if age > Constants.Cache.maxCacheAge {
                    try? fileManager.removeItem(at: file)
                }
            }
        }
    }
}
