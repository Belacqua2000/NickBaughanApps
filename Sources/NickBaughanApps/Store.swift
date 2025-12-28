//
//  Store.swift
//  Hills
//
//  Created by Nick Baughan on 04/11/2025.
//

import Foundation
import OSLog

@available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
@Observable
public class Store<T: Codable & Hashable> {
    public var items: Set<T> {
        get {
            access(keyPath: \.items)
            return loadFromUserDefaults()
        }
        set(newItems) {
            withMutation (keyPath: \.items) {
//                withAnimation {
                    saveToUserDefaults(newItems)
//                }
            }
        }
    }
    
    let userDefaultsKey: String
    private let store: UserDefaults
    private let logger: Logger
    
    public init(key: String, store: UserDefaults = .standard, defaultItems: Set<T> = []) {
        userDefaultsKey = key
        self.store = store
        logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Store for \(key)")
        if store.data(forKey: key) == nil {
            items = defaultItems
        }
    }
    
    private func saveToUserDefaults(_ items: Set<T>) {
        logger.debug("Attempting to save: \(items.description)")
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(items) {
            store.set(encodedData, forKey: userDefaultsKey)
            logger.debug("Saved: \(encodedData.description)")
        }
    }
    
    private func loadFromUserDefaults() -> Set<T> {
        if let data = store.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let items = try? decoder.decode(Set<T>.self, from: data) {
                logger.debug("Loaded: \(items.description)")
                return items
            } else {
                logger.error("Could not decode data.")
            }
        }
        return []
    }
}
