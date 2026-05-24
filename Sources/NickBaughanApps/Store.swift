//
//  Store.swift
//  Hills
//
//  Created by Nick Baughan on 04/11/2025.
//

import Observation
import OSLog

@available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
@Observable
@propertyWrapper
public class Store<Item: Codable> {
    
    public var wrappedValue: Item {
        get {
            access(keyPath: \.wrappedValue)
            return loadFromUserDefaults()
        }
        set {
            withMutation(keyPath: \.wrappedValue) {
                saveToUserDefaults(newValue)
            }
        }
    }
    
    public var projectedValue: Item { wrappedValue }
    
    let userDefaultsKey: String
    private let store: UserDefaults
    private let logger: Logger
    private let defaultValue: Item
    
    public init(wrappedValue defaultValue: Item, key: String, store: UserDefaults = .standard) {
        userDefaultsKey = key
        self.store = store
        self.defaultValue = defaultValue
        logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Store for \(key)")
    }
    
    private func saveToUserDefaults(_ item: Item) {
        if let item = item as? CustomStringConvertible {
            logger.debug("Attempting to save: \(item.description)")
        }
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(item) {
            store.set(encodedData, forKey: userDefaultsKey)
            logger.debug("Saved: \(encodedData.description)")
        }
    }
    
    private func loadFromUserDefaults() -> Item {
        guard let data = store.data(forKey: userDefaultsKey) else {
            return defaultValue
        }
        
        do {
            let item = try JSONDecoder().decode(Item.self, from: data)
            if let item = item as? CustomStringConvertible {
                logger.debug("Decoded: \(item.description)")
            }
            return item
        } catch {
            logger.error("Failed to decode value for key \(self.userDefaultsKey)")
            return defaultValue
        }
    }
}


