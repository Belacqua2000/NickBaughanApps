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
    
    /// A user-facing description of the version.
    ///
    /// This is in the format ``majorNumber``.``minorNumber``.``thirdNumber`` or ``majorNumber``.``minorNumber``.
    public var minimalDescription: String { thirdNumber == 0 ? "\(majorNumber).\(minorNumber)" : description }
    
    init(from string: String) {
        let numbers = string.split(separator: ".")
        let majorNumber = Int(numbers[0]) ?? 1
        let minorNumber = Int(numbers[1]) ?? 0
        let patchNumber: Int = numbers.count == 3 ? Int(numbers[2]) ?? 0 : 0
        self.init(majorNumber: majorNumber, minorNumber: minorNumber, thirdNumber: patchNumber)
    }
    
    public init(majorNumber: Int, minorNumber: Int, thirdNumber: Int, @NewFeatureBuilder newFeatures: () -> [NewFeature] = { [] }) {
        self.majorNumber = majorNumber
        self.minorNumber = minorNumber
        self.thirdNumber = thirdNumber
        self.newFeatures = newFeatures()
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
