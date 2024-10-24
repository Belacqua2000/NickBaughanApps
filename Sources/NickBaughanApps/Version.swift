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
    public let newFeatures: [NewFeature] = []
    
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
    
    public init(majorNumber: Int, minorNumber: Int, thirdNumber: Int) {
        self.majorNumber = majorNumber
        self.minorNumber = minorNumber
        self.thirdNumber = thirdNumber
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

/// A new feature of the app.
public struct NewFeature: Identifiable, Hashable, Sendable {
    
    /// The title of the new feature.
    public let title: String
    
    /// The description of the new feature.
    public let description: AttributedString?
    
    /// The SF symbol corresponding to the new feature.
    public let iconName: String
    
    public let id = UUID()
}
