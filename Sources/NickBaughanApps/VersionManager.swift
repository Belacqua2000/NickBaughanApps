//
//  VersionManager.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 24/10/2024.
//

import Foundation

/// An object which stores app versions, their features, and the currently viewed feature.
///
/// Set this as a global constant, with all versions.
public struct VersionManager: Sendable {
    public let allVersions: [Version]
    
    public var unseenVersions: [Version] {
        allVersions
            .filter { $0 > lastSavedVersion ?? Version(majorNumber: 0, minorNumber: 0, thirdNumber: 0) }
            .sorted()
            .reversed()
    }
    
    public init(allVersions: [Version]) {
        self.allVersions = allVersions
    }
    
    /// The current version, obtained from the Bundle key.
    public var currentVersion: Version? {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return allVersions.first { $0.id == appVersion }
    }
    
    let lastSavedVersionKey = "WhatsNewVersionID"
    
    /// Get the last saved version from UserDefaults.
    public var lastSavedVersion: Version? {
        get {
            guard let lastSavedVersionID = UserDefaults.standard.string(forKey: lastSavedVersionKey) else { return nil }
            return allVersions.first { $0.id == lastSavedVersionID }
        }
    }
    
    /// This will save the current version as the most up-to-date version.
    public func setCurrentVersionAsLastSaved() {
        UserDefaults.standard.set(currentVersion?.id, forKey: lastSavedVersionKey)
    }
    
}
