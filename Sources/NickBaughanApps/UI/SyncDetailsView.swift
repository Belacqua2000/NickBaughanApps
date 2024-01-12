//
//  SyncDetailsView.swift
//
//
//  Created by Nick Baughan on 18/11/2023.
//

import SwiftUI
import CoreData

@available(iOS 17.0, macOS 14, watchOS 10, *)
public struct SyncDetailsView: View {
    public init() { }
    
    @Environment(iCloudSyncModel.self) private var syncModel
    
//    @AppStorage("lastSync") private var lastSync: Double?
//    @AppStorage("currentSyncStart") private var currentSyncStart: Double?
//    @State private var currentEvent: NSPersistentCloudKitContainer.Event? = nil
    
//    @AppStorage("syncError") private var syncError: String?
//    @State private var failureAlertPresented: Bool = false
//    @State private var detailsPresented: Bool = false
    
    var lastSyncDate: String {
        if let lastSync = syncModel.lastSync {
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
    
    var currentSyncDate: Text {
        if let currentSyncStart = syncModel.currentSyncStart {
            let date = Date(timeIntervalSince1970: currentSyncStart)
            return Text(date, style: .relative)
        }
        return Text("Never")
    }
    
    public var body: some View {
        Form {
            FormViewDescription(imageName: "icloud", description: AttributedString(localized: "View the current iCloud Sync Status."))
            Section {
                LabeledContent(
                    "Sync Status",
                    value: syncModel.syncInProgress ? "In Progress" : "Not in Progress"
                )
                if syncModel.syncInProgress, let description = syncModel.currentSyncDescription {
                    LabeledContent("Type", value: description)
                    LabeledContent("Start Date") {
                        currentSyncDate
                    }
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
                LabeledContent("Error", value: syncModel.syncError?.localizedDescription ?? "None")
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
    }
    
//    private func iCloudSyncChanged(output: NotificationCenter.Publisher.Output) {
//        guard let event = output.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else { return }
        
//        currentSyncStart = event.startDate.timeIntervalSince1970
//        lastSync = event.endDate?.timeIntervalSince1970
//        syncError = event.error?.localizedDescription
//    }
}

@available(iOS 17.0, macOS 14, watchOS 10, *)
#Preview {
    SyncDetailsView()
}
