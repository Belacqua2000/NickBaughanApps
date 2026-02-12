//
//  VersionManager.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 24/10/2024.
//

import Foundation
import SwiftUI

/// An object which stores app versions, their features, and the currently viewed feature.
public struct VersionManager: Sendable {
    public let allVersions: [Version]
    
    public var unseenVersions: [Version] {
        allVersions
            .filter { $0 > lastSavedVersion ?? Version(majorNumber: 0, minorNumber: 0, thirdNumber: 0) }
            .sorted()
            .reversed()
    }
    
    public init(@VersionBuilder _ builder: () -> [Version]) {
        self.allVersions = builder()
    }
    
    /// The current version, obtained from the Bundle key.
    public var currentVersion: Version? {
        var appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let numbers = appVersion.split(separator: ".")
        if numbers.count == 2 {
            appVersion.append(".0")
        }
        return allVersions.first { $0.id == appVersion }
    }
    
    /// The latest version, defined in allVersions.
    public var latestVersion: Version? {
        return allVersions.max()
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
        UserDefaults.standard.set(latestVersion?.id, forKey: lastSavedVersionKey)
    }
}

extension EnvironmentValues {
    @Entry var versionManager: VersionManager?
}

/// Scene extension for adding version management to your App
extension Scene {
    public func versionManager(@VersionBuilder _ builder: @escaping () -> [Version]) -> some Scene {
        let manager = VersionManager(builder)
        return self.environment(\.versionManager, manager)
    }
}
