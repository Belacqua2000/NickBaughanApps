//
//  SyncStatusView.swift
//  Chronoderm
//
//  Created by Nick Baughan on 20/10/2022.
//

import SwiftUI
import CoreData

@available(iOS 17.0, macOS 14, watchOS 10, *)
struct SyncStatusView: View {
    @State private var failureAlertPresented: Bool = false
    
    @Environment(iCloudSyncModel.self) private var syncModel
    
    var stackSpacing: CGFloat? {
        #if os(watchOS)
        nil
        #else
        5
        #endif
    }
    
    var labelInfo: (title: Text, iconName: String)? {
        if syncModel.syncInProgress {
            return (Text(syncModel.currentSyncDescription ?? "Syncing in Progress"), "arrow.clockwise.icloud")
        } else if syncModel.syncError != nil {
            return (Text("iCloud Sync Failed"), "xmark.icloud")
        } else if let lastSync = syncModel.lastSync {
            let date = Date(timeIntervalSince1970: lastSync)
            let format: Date.FormatStyle
            if Calendar.current.isDateInToday(date) {
                format = .init(date: .omitted, time: .shortened, capitalizationContext: .middleOfSentence)
            } else {
                format = .init(date: .numeric, time: .shortened, capitalizationContext: .middleOfSentence)
            }
            return (Text("Last Synced: \(date.formatted(format))"), "checkmark.icloud")
        } else {
            return nil
        }
    }
    
    var body: some View {
        if let labelInfo {
            VStack(spacing: 0) {
                Image(systemName: labelInfo.iconName)
                    .foregroundStyle(Color.accentColor)
                    .symbolVariant(.fill)
                    .font(.headline)
                Text("iCloud Status")
                    .font(.headline)
                HStack(spacing: 5) {
                    #if !os(watchOS)
                    if syncModel.syncInProgress {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.mini)
                    }
                    #endif
                    labelInfo.title
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                if syncModel.syncError != nil {
                    Button {
                        failureAlertPresented = true
                    } label: {
                        Label("More Details", systemImage: "info.circle")
                    }
                    .labelStyle(.iconOnly)
                    .help("View additional details about the sync error.")
                    .buttonStyle(.borderless)
                }
            }
            .symbolRenderingMode(.hierarchical)
            .alert("Sync Failed", isPresented: $failureAlertPresented) {} message: {
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
