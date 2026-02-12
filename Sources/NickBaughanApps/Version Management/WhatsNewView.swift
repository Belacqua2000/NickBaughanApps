//
//  WhatsNew.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 12/02/2026.
//


//
//  WhatsNew.swift
//  Ailsa
//
//  Created by Nick Baughan on 24/10/2024.
//

import SwiftUI

public struct WhatsNewView: View {
    public init(appName: String) {
        self.appName = appName
    }
    
    @Environment(\.versionManager) private var versionManager
    var versions: [Version] {
        guard let versionManager else { return [] }
        if !versionManager.unseenVersions.isEmpty {
            return versionManager.unseenVersions
        } else {
            return versionManager.allVersions.sorted().reversed()
        }
    }
    
    var appName: String
    
    @State private var selectedItem: NewFeature.ID?
    
    public var body: some View {
        if let versionManager {
            Form {
                VStack {
                    Image(systemName: "party.popper")
                        .font(.largeTitle)
                        .symbolRenderingMode(.hierarchical)
                        .imageScale(.large)
                        .foregroundStyle(Color.accentColor)
                    //                    .padding()
                    Text(
                        !versionManager.unseenVersions.isEmpty ?
                        "Here's what has changed since you last used \(appName)."
                        :
                            "Here's what has recently changed with \(appName)."
                    )
                    .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                
                ForEach(versions) { version in
                    Section("Version \(version.description)") {
                        ForEach(version.newFeaturesCompatibleWithCurrentDevice) { feature in
                            FeatureLabel(feature: feature)
                                .selectable()
                        }
                    }
                }
            }
#if !os(tvOS)
            .navigationTitle("What's New")
#endif
            .formStyle(.grouped)
#if os(macOS)
            .frame(width: 600, height: 400)
#endif
        }
    }
}

struct FeatureLabel: View {
    var feature: NewFeature
    
    var body: some View {
        Label {
            Text(feature.title)
            if let description = feature.description {
                Text(description)
                    #if os(tvOS)
                    .foregroundStyle(.secondary)
                    #endif
            }
        } icon: {
            Image(systemName: feature.iconName)
        }
    }
}

#Preview {
    CPNavigationView {
        WhatsNewView(appName: "Test")
    }
}
