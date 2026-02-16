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

/// A view that presents What's New information grouped by app version.
///
/// The view reads version information from the environment and lists features for each version.
/// If there are unseen versions, those are shown; otherwise, the most recent versions are listed.
///
/// You can customize the appearance of each section header by providing a `sectionHeader` closure
/// when initializing the view.
public struct WhatsNewView: View {
    
    /// Creates a What's New view.
    /// - Parameters:
    ///   - appName: The display name of your app, used in the introductory text.
    ///   - sectionHeader: A closure that receives the default section header text (for example, "Version 1.2.3")
    ///     and returns a modified `Text`. Use this to style the header; defaults to the identity closure.
    ///
    /// - Example:
    ///   ```swift
    ///   WhatsNewView(appName: "MyApp") { header in
    ///       header.font(.headline).foregroundStyle(.tint)
    ///   }
    ///   ```
    public init(appName: String, sectionHeader: @escaping (_ header: Text) -> Text = { $0 }) {
        self.appName = appName
        self.sectionHeader = sectionHeader
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
    /// A closure that styles the section header text. Defaults to the identity closure.
    var sectionHeader: (Text) -> Text
    
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
                    Section {
                        ForEach(version.newFeaturesCompatibleWithCurrentDevice) { feature in
                            FeatureLabel(feature: feature)
                                .selectable()
                        }
                    } header: {
                        sectionHeader(Text("Version \(version.description)"))
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
        WhatsNewView(appName: "Test") { text in
            text.font(.headline)
        }
    }
}
