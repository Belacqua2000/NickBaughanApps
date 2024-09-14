//
//  Version.swift
//  
//
//  Created by Nick Baughan on 28/12/2022.
//

import Foundation

public struct Version: Identifiable, Hashable, Sendable {
    let majorNumber: Int
    let minorNumber: Int
    let thirdNumber: Int
    public var id: String { "\(majorNumber).\(minorNumber).\(thirdNumber)" }
    
    public var string: String { "\(majorNumber).\(minorNumber).\(thirdNumber)" }
    
    init(from string: String) {
        let numbers = string.split(separator: ".")
        let majorNumber = Int(numbers[0]) ?? 1
        let minorNumber = Int(numbers[1]) ?? 0
        let patchNumber: Int = numbers.count == 3 ? Int(numbers[2]) ?? 0 : 0
        self.init(majorNumber: majorNumber, minorNumber: minorNumber, thirdNumber: patchNumber)
    }
    
    init(majorNumber: Int, minorNumber: Int, thirdNumber: Int) {
        self.majorNumber = majorNumber
        self.minorNumber = minorNumber
        self.thirdNumber = thirdNumber
    }
    
    public let newFeatures: [NewFeature] = []
    
    
    public static var current: Version {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return Version(from: appVersion)
    }
    
    public static var lastSavedVersion: Version? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "WhatsNewVersion") else { return nil }
            return try? JSONDecoder().decode(Version.self, from: data)
        } set {
            if let data = try? JSONEncoder().encode(Version.current) {
                UserDefaults.standard.set(data, forKey: "WhatsNewVersion")
            }
        }
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

extension Version: Codable {
    private enum CodingKeys: CodingKey {
        case majorNumber, minorNumber, thirdNumber
    }
}

public struct NewFeature: Identifiable, Hashable, Sendable {
    public let title: String
    public let description: AttributedString?
    public let image: String
    public var id: String { "\(title)" }
}
