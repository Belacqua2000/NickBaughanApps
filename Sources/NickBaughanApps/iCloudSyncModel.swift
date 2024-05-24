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
public class iCloudSyncModel {
    public init(syncInProgress: Bool = false, syncError: Error? = nil, detailsPresented: Bool = false) {
        self.syncInProgress = syncInProgress
        self.syncError = syncError
        self.detailsPresented = detailsPresented
        
        iCloudUpdateTask = listenForiCloudUpdate()
    }
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "iCloud Sync")
    
    private var iCloudUpdateTask: Task<Void, Error>? = nil
    
    var lastSync: Double? {
        get {
            UserDefaults.standard.double(forKey: "lastSync")
        } 
        set {
            UserDefaults.standard.setValue(newValue, forKey: "lastSync")
        }
    }
    
    var currentSyncStart: Double? {
        get {
            UserDefaults.standard.double(forKey: "currentSyncStart")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentSyncStart")
        }
    }
    
    var syncInProgress: Bool {
        get {
            UserDefaults.standard.bool(forKey: "syncInProgress")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "syncInProgress")
        }
    }
    
    var currentSyncDescription: String? {
        get {
            UserDefaults.standard.string(forKey: "currentSyncDescription")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentSyncDescription")
        }
    }
    
    var syncError: Error?
//    var failureAlertPresented: Bool = false
    var detailsPresented: Bool = false
    
    func listenForiCloudUpdate() -> Task<Void, Error> {
        return Task {
            for await notification in NotificationCenter.default.notifications(named: NSPersistentCloudKitContainer.eventChangedNotification) {
                guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else { continue }
                
                withAnimation {
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
                }
            }
        }
    }
}

extension NSPersistentCloudKitContainer.EventType {
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
