//
//  Platforms.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 12/02/2026.
//


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