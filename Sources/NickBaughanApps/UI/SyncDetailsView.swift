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
        return String(localized: "Never", bundle: .module, comment: "Last sync date text")
    }
    
    var currentSyncDateOffset: Text {
        if let currentSyncStart = syncModel.currentSyncStart {
            let date = Date(timeIntervalSince1970: currentSyncStart)
            return Text(date, style: .relative)
        }
        return Text("Never", bundle: .module, comment: "Last sync date text")
    }
    
    public var body: some View {
        Form {
            FormViewDescription(imageName: "icloud", description: AttributedString(localized: "View the current iCloud Sync Status.", bundle: .module, comment: "The iCloud sync status view description."))
            Section {
                LabeledContent(
                    String(localized: "Status", bundle: .module, comment: "iCloud sync details stat title."),
                    value: syncModel.syncInProgress ? "In Progress" : "Not in Progress"
                )
                if syncModel.syncInProgress, let description = syncModel.currentSyncDescription {
                    LabeledContent(
                        String(localized: "Type", bundle: .module, comment: "iCloud sync details stat title."),
                        value: description)
                    LabeledContent(
                        String(localized: "Start Date", bundle: .module, comment: "iCloud sync details stat title.")) {
                        currentSyncDateOffset
                    }
                }
            } header: {
                Text("Current Sync", bundle: .module, comment: "Sync details section header.")
                    .font(.headline)
                    .headerProminence(.increased)
                    .textCase(nil)
                    .foregroundStyle(.purple)
            }
            
            Section {
                LabeledContent(String(localized: "Last Sync Date", bundle: .module, comment: "iCloud sync details stat title."), value: lastSyncDate)
                LabeledContent(String(localized: "Error", bundle: .module, comment: "iCloud sync details stat title."), value: syncModel.syncError?.localizedDescription ?? "None")
            } header: {
                Text("Last Sync", bundle: .module, comment: "Sync details section header.")
                    .font(.headline)
                    .headerProminence(.increased)
                    .textCase(nil)
                    .foregroundStyle(.purple)
            }
        }
        .navigationTitle(Text("iCloud Status", bundle: .module, comment: "The navigation title for the sync details view."))
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

@available(iOS 17.0, macOS 14, watchOS 10, *)
#Preview {
    SyncDetailsView()
}
