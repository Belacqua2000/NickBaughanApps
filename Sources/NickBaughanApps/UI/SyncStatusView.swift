//
//  SyncStatusView.swift
//  Chronoderm
//
//  Created by Nick Baughan on 20/10/2022.
//

import SwiftUI
import CoreData

@available(iOS 17.0, macOS 14, watchOS 10, *)
public struct SyncStatusView: View {
    public init() { }
    
    @State private var failureAlertPresented: Bool = false
    
    @Environment(iCloudSyncModel.self) private var syncModel
    
    var stackSpacing: CGFloat? {
        #if os(watchOS)
        nil
        #else
        5
        #endif
    }
    
    var labelInfo: (title: String, iconName: String)? {
        if syncModel.syncInProgress, let description = syncModel.currentSyncDescription {
            return (description, "arrow.clockwise.icloud")
        } else if syncModel.syncError != nil {
            return (String(localized: "iCloud Sync Failed", bundle: .module, comment: "Sync status view text option."), "xmark.icloud")
        } else if let lastSync = syncModel.lastSync {
            let date = Date(timeIntervalSince1970: lastSync)
            let format: Date.FormatStyle
            if Calendar.current.isDateInToday(date) {
                format = .init(date: .omitted, time: .shortened, capitalizationContext: .middleOfSentence)
            } else {
                format = .init(date: .numeric, time: .shortened, capitalizationContext: .middleOfSentence)
            }
            return (String(localized: "Last Synced: \(date.formatted(format))", bundle: .module, comment: "Sync status view text option."), "checkmark.icloud")
        } else {
            return nil
        }
    }
    
    public var body: some View {
        if let labelInfo {
            VStack(spacing: 0) {
                Image(systemName: labelInfo.iconName)
                    .foregroundStyle(Color.accentColor)
                    .symbolVariant(.fill)
                    .font(.headline)
                Text("iCloud Status", comment: "iCloud status view header.")
                    .font(.headline)
                HStack(spacing: 5) {
                    #if !os(watchOS)
                    if syncModel.syncInProgress {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.mini)
                    }
                    #endif
                    Text(labelInfo.title)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                if syncModel.syncError != nil {
                    Button {
                        failureAlertPresented = true
                    } label: {
                        Label(String(localized: "More Details", bundle: .module, comment: "The button title to show why an iCloud sync failed."), systemImage: "info.circle")
                    }
                    .labelStyle(.iconOnly)
                    .help(String(localized: "View additional details about the sync error", bundle: .module, comment: "The help string for the button to show why an iCloud sync failed."))
                    .buttonStyle(.borderless)
                }
            }
            .symbolRenderingMode(.hierarchical)
            .alert(String(localized: "Sync Failed", bundle: .module, comment: "The alert title for iCloud Sync falure"), isPresented: $failureAlertPresented) {} message: {
                if let syncError = syncModel.syncError {
                    Text(syncError.localizedDescription)
                }
            }
            #if os(watchOS)
            .frame(maxWidth: .infinity)
            #endif
        }
    }
}

@available(iOS 17.0, macOS 14, watchOS 10, *)
#Preview {
    SyncStatusView()
        .environment(iCloudSyncModel())
}
