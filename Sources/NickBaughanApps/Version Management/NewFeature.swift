//
//  NewFeature.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 12/02/2026.
//

import Foundation

/// A new feature of the app.
public struct NewFeature: Identifiable, Hashable, Sendable {
    public init(title: String, description: AttributedString?, iconName: String, supportedPlatforms: Platforms = .all) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.supportedPlatforms = supportedPlatforms
    }
    
    /// The title of the new feature.
    public let title: String
    
    /// The description of the new feature.
    public let description: AttributedString?
    
    /// The SF symbol corresponding to the new feature.
    public let iconName: String
    
    /// The platforms the feature is available on.
    public let supportedPlatforms: Platforms
    
    public let id = UUID()
}
