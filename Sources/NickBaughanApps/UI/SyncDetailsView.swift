//
//  SyncDetailsView.swift
//
//
//  Created by Nick Baughan on 18/11/2023.
//

import SwiftUI
import CoreData

@available(iOS 17.0, macOS 14, watchOS 10, tvOS 17, *)
public struct SyncDetailsView: View {
    public init() { }
    
    @Environment(iCloudSyncModel.self) private var syncModel
    
    public var body: some View {
        Form {
            FormViewDescription(imageName: "icloud", description: AttributedString(localized: "View the current iCloud Sync Status.", bundle: .module, comment: "The iCloud sync status view description."))
            Section {
                LabeledContent(
                    String(localized: "Status", bundle: .module, comment: "iCloud sync details stat title."),
                    value: syncModel.syncStatus
                )
                .selectable()
                if syncModel.syncInProgress, let description = syncModel.lastEvent?.eventType.userDescription {
                    LabeledContent(
                        String(localized: "Type", bundle: .module, comment: "iCloud sync details stat title."),
                        value: description)
                    LabeledContent(
                        String(localized: "Start Date", bundle: .module, comment: "iCloud sync details stat title.")) {
                            if let startDate = syncModel.lastEvent?.startDate {
                                Text(startDate, style: .relative)
                            } else {
                                Text("Never", bundle: .module, comment: "Last sync date text")
                            }
                    }
                }
            } header: {
                Text("Current Sync", bundle: .module, comment: "Sync details section header.")
//                    .font(.headline)
//                    .headerProminence(.increased)
//                    .textCase(nil)
//                    .foregroundStyle(.purple)
            }
            
            if let lastSync = syncModel.lastEvent, !syncModel.syncInProgress {
                Section {
                    LabeledContent(String(localized: "Last Sync", bundle: .module, comment: "iCloud sync details stat title.")) {
                        let date = lastSync.startDate
                        Text(date, format: Date.FormatStyle(date: Calendar.current.isDateInToday(date) ? .omitted : .numeric, time: .shortened, capitalizationContext: .middleOfSentence))
                    }
                    .selectable()
                    if let error = lastSync.errorDescription {
                        LabeledContent(String(localized: "Error", bundle: .module, comment: "iCloud sync details stat title."), value: error)
                    }
                } header: {
                    Text("Last Sync", bundle: .module, comment: "Sync details section header.")
    //                    .font(.headline)
    //                    .headerProminence(.increased)
    //                    .textCase(nil)
    //                    .foregroundStyle(.purple)
                }
            }
        }
        .navigationTitle(Text("iCloud Status", bundle: .module, comment: "The navigation title for the sync details view."))
        .toolbarTitleDisplayMode(.inline)
    }
}

@available(iOS 17.0, macOS 14, watchOS 10, tvOS 17, *)
#Preview {
    SyncDetailsView()
        .environment(iCloudSyncModel.shared)
        .formStyle(.grouped)
}
