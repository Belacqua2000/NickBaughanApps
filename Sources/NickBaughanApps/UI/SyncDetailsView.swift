//
//  SyncDetailsView.swift
//
//
//  Created by Nick Baughan on 18/11/2023.
//

import SwiftUI
import CoreData

public struct SyncDetailsView: View {
    public init() { }
    
    @AppStorage("lastSync") private var lastSync: Double?
    @AppStorage("currentSyncStart") private var currentSyncStart: Double?
    @State private var currentEvent: NSPersistentCloudKitContainer.Event? = nil
    
    @AppStorage("syncError") private var syncError: String?
    @State private var failureAlertPresented: Bool = false
    @State private var detailsPresented: Bool = false
    
    var lastSyncDate: String {
        if let lastSync {
            let date = Date(timeIntervalSince1970: lastSync)
            let format: Date.FormatStyle
            if Calendar.current.isDateInToday(date) {
                format = .init(date: .omitted, time: .shortened, capitalizationContext: .middleOfSentence)
            } else {
                format = .init(date: .numeric, time: .shortened, capitalizationContext: .middleOfSentence)
            }
            return date.formatted(format)
        }
        return String("Never")
    }
    
    var currentSyncDate: String {
        if let currentSyncStart {
            let date = Date(timeIntervalSince1970: currentSyncStart)
            let format: Date.FormatStyle
            if Calendar.current.isDateInToday(date) {
                format = .init(date: .omitted, time: .shortened, capitalizationContext: .middleOfSentence)
            } else {
                format = .init(date: .numeric, time: .shortened, capitalizationContext: .middleOfSentence)
            }
            return date.formatted(format)
        }
        return String("Never")
    }
    
    public var body: some View {
        Form {
            FormViewDescription(imageName: "icloud", description: AttributedString(localized: "View the current iCloud Sync Status."))
            Section {
                LabeledContent(
                    "Sync Status",
                    value: currentEvent != nil && currentEvent?.endDate == nil && currentEvent?.error == nil ? "In Progress" : "Not in Progress"
                )
                if let currentEvent, currentEvent.endDate == nil, currentEvent.error == nil {
                    LabeledContent("Type", value: descriptionFor(currentEvent.type))
                    LabeledContent("Start Date", value: currentSyncDate)
                }
            } header: {
                Text("Current Sync")
                    .font(.headline)
                    .headerProminence(.increased)
                    .textCase(nil)
                    .foregroundStyle(.purple)
            }
            
            Section {
                LabeledContent("Last Sync Date", value: lastSyncDate)
                LabeledContent("Error", value: syncError ?? "None")
            } header: {
                Text("Last Sync")
                    .font(.headline)
                    .headerProminence(.increased)
                    .textCase(nil)
                    .foregroundStyle(.purple)
            }
        }
        .navigationTitle("iCloud Sync Status")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onReceive(NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification, object: nil), perform: iCloudSyncChanged)
    }
    
    private func iCloudSyncChanged(output: NotificationCenter.Publisher.Output) {
        guard let event = output.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else { return }
        
        print("iCloud sync changed")
        print(event)
        lastSync = event.startDate.timeIntervalSince1970
        lastSync = event.endDate?.timeIntervalSince1970
        syncError = event.error?.localizedDescription
    }
    
    private func descriptionFor(_ eventType: NSPersistentCloudKitContainer.EventType) -> String {
        switch eventType {
        case .setup:
            "Setting Up Sync"
        case .import:
            "Downloading Data"
        case .export:
            "Uploading Data"
        @unknown default:
            "Unknown"
        }
    }
}

#Preview {
    SyncDetailsView()
}
