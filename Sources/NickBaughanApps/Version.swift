//
//  Version.swift
//  
//
//  Created by Nick Baughan on 28/12/2022.
//

import Foundation

/// A version of the app.
public struct Version: Identifiable, Hashable, Sendable, CustomStringConvertible {
    /// The major version number.
    let majorNumber: Int
    /// The minor version number.
    let minorNumber: Int
    /// The patch version number.
    let thirdNumber: Int
    
    /// New features which are included in this version, which can then be displayed within a user interface.
    public let newFeatures: [NewFeature]
    
    /// New features which are included in this version, which are compatible with the current device.
    ///
    /// Use this in a 'What's New' page.
    public var newFeaturesCompatibleWithCurrentDevice: [NewFeature] {
        newFeatures.filter { $0.supportedPlatforms.includeCurrentDevice }
    }
    
    public var id: String { "\(majorNumber).\(minorNumber).\(thirdNumber)" }
    
    /// A user-facing description of the version.
    ///
    /// This is in the format ``majorNumber``.``minorNumber``.``thirdNumber``.
    public var description: String { "\(majorNumber).\(minorNumber).\(thirdNumber)" }
    
    init(from string: String) {
        let numbers = string.split(separator: ".")
        let majorNumber = Int(numbers[0]) ?? 1
        let minorNumber = Int(numbers[1]) ?? 0
        let patchNumber: Int = numbers.count == 3 ? Int(numbers[2]) ?? 0 : 0
        self.init(majorNumber: majorNumber, minorNumber: minorNumber, thirdNumber: patchNumber)
    }
    
    public init(majorNumber: Int, minorNumber: Int, thirdNumber: Int, newFeatures: [NewFeature] = []) {
        self.majorNumber = majorNumber
        self.minorNumber = minorNumber
        self.thirdNumber = thirdNumber
        self.newFeatures = newFeatures
    }
}

extension Version: Comparable {
    public static func == (lhs: Version, rhs: Version) -> Bool {
        lhs.majorNumber == rhs.majorNumber &&
        lhs.minorNumber == rhs.minorNumber &&
        lhs.thirdNumber == rhs.thirdNumber
    }
    
    public static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.majorNumber != rhs.majorNumber {
            return lhs.majorNumber < rhs.majorNumber
        } else if lhs.minorNumber != rhs.minorNumber {
            return lhs.minorNumber < rhs.minorNumber
        } else {
            return lhs.thirdNumber < rhs.thirdNumber
        }
    }
}

public struct Platforms: OptionSet, Sendable, Hashable {
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let macOS = Platforms(rawValue: 1 << 0)
    public static let iOS = Platforms(rawValue: 1 << 1)
    public static let tvOS = Platforms(rawValue: 1 << 2)
    public static let watchOS = Platforms(rawValue: 1 << 3)
    public static let visionOS = Platforms(rawValue: 1 << 4)
    
    /// All of the current Apple platforms.
    public static let all: Platforms = [.macOS, .iOS, .tvOS, .watchOS, .visionOS]
    public static let supportsTouch: Platforms = [.iOS, .watchOS, .visionOS]
    public static let supportsKeyboard: Platforms = [.iOS, .macOS, .visionOS]
    public static let supportsPointer: Platforms = [.iOS, .macOS, .visionOS]
    
    /// Whether the platforms include the current device.
    public var includeCurrentDevice: Bool {
        #if os(macOS)
        self.contains(.macOS)
        #elseif os(iOS)
        self.contains(.iOS)
        #elseif os(tvOS)
        self.contains(.tvOS)
        #elseif os(visionOS)
        self.contains(.visionOS)
        #elseif os(watchOS)
        self.contains(.watchOS)
        #else
        false
        #endif
    }
}

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
