//
//  iCloudSyncModel.swift
//
//  Created by Nick Baughan on 21/12/2023.
//

import SwiftUI
import CoreData
import OSLog
#if canImport(WidgetKit)
import WidgetKit
#endif

@available(iOS 17.0, macOS 14, watchOS 10, tvOS 17, *)
@Observable
@MainActor
public class iCloudSyncModel {
    private init() {
        iCloudUpdateTask = listenForiCloudUpdate()
        Task {
            await loadSyncStatus()
        }
    }
    
    public static let shared: iCloudSyncModel = iCloudSyncModel()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "iCloud Sync")
    
    private let store = iCloudStore()
    
    private var iCloudUpdateTask: Task<Void, Error>? = nil
    
    func listenForiCloudUpdate() -> Task<Void, Error> {
        return Task.detached {
            for await notification in NotificationCenter.default.notifications(named: NSPersistentCloudKitContainer.eventChangedNotification) {
                guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else { continue }
                await self.updateSyncStatus(with: SyncEvent(event: event))
            }
        }
    }
    
    var lastEvent: SyncEvent?
    
    func updateSyncStatus(with event: SyncEvent) async {
        lastEvent = event
        do {
            try await store.save(event)
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    func loadSyncStatus() async {
        do {
            lastEvent = try await store.load()
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    var syncInProgress: Bool {
        if let lastEvent {
            return lastEvent.endDate == nil && lastEvent.errorDescription == nil
        }
        return false
    }
    
    var syncStatus: String {
        if let lastEvent {
            if lastEvent.endDate == nil && lastEvent.errorDescription == nil {
                return "Syncing…"
            } else if lastEvent.succeeded {
                return "Synced"
            } else {
                return "Error: \(lastEvent.errorDescription ?? "")"
            }
        } else {
            return "Never Synced"
        }
    }
    
    var syncError: Error?
    var detailsPresented: Bool = false
    
}

struct SyncEvent: Codable, Sendable {
    init(event: NSPersistentCloudKitContainer.Event) {
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.eventType = event.type
        self.errorDescription = event.error?.localizedDescription
        self.id = event.identifier
        self.succeeded = event.succeeded
    }
    
    var id: UUID
    var startDate: Date
    var endDate: Date?
    var eventType: NSPersistentCloudKitContainer.EventType
    var errorDescription: String?
    var succeeded: Bool
}

actor iCloudStore {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    func save(_ event: SyncEvent) throws {
        let data = try encoder.encode(event)
        UserDefaults.standard.set(data, forKey: "iCloudSyncEvent")
    }
    
    func load() throws -> SyncEvent? {
        if let data = UserDefaults.standard.data(forKey: "iCloudSyncEvent") {
            return try decoder.decode(SyncEvent.self, from: data)
        }
        return nil
    }
}

extension NSPersistentCloudKitContainer.EventType: @retroactive Codable {
    var userDescription: String {
        switch self {
        case .setup:
            String(localized: "Setting Up Sync", bundle: .module, comment: "iCloud Sync Status user description")
        case .import:
            String(localized: "Downloading Data", bundle: .module, comment: "iCloud Sync Status user description")
        case .export:
            String(localized: "Uploading Data", bundle: .module, comment: "iCloud Sync Status user description")
        @unknown default:
            String(localized: "Unknown", bundle: .module, comment: "iCloud Sync Status user description")
        }
    }
}


/*withAnimation {
    logger.info("iCloud Model")
    logger.debug("\(event)")
    syncInProgress = event.endDate == nil && event.error == nil
    logger.debug("Sync in progress: \(event.endDate == nil && event.error == nil ? "Yes" : "No")")
    if let endDate = event.endDate {
        lastSync = endDate.timeIntervalSince1970
    }
    currentSyncStart = event.startDate.timeIntervalSince1970
    logger.debug("Last sync updated to: \(event.startDate.timeIntervalSince1970)")
    syncError = event.error
    
    if syncInProgress {
        currentSyncDescription = event.type.userDescription
    } else {
        currentSyncDescription = nil
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
    logger.debug("Current Description: \(self.currentSyncDescription ?? "NIL")")
    
    if let syncError {
        logger.error("Sync Error: \(syncError.localizedDescription)")
    }
}*/
