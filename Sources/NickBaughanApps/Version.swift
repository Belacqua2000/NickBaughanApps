//
//  Version.swift
//  
//
//  Created by Nick Baughan on 28/12/2022.
//

import Foundation

public struct Version: Identifiable, Hashable {
    
    let majorNumber: Int
    let minorNumber: Int
    let thirdNumber: Int
    public var id: String { "\(majorNumber).\(minorNumber).\(thirdNumber)" }
    
    public var newFeatures: [NewFeature] = []
    
    public static func saveWhatsNew() {
        if let data = try? JSONEncoder().encode(latest) {
            UserDefaults.standard.set(data, forKey: "WhatsNewVersion")
        }
    }
    
    /*public static let version1 = Version(majorNumber: 1, minorNumber: 1, thirdNumber: 0, newFeatures: [
        .init(title: "Shortcuts and Siri", description: "Derm Diary features next-level integration with the Shortcuts app!  18 actions to create, find, edit, open, and share your diaries and entries are ready to be integrated into your workflows.", image: "gearshape.2"),
        .init(title: "Diaries and Bookmarks", description: "Skin features have been renamed to skin diaries.  Add bookmarks to notable entries to view them separately.", image: "text.book.closed"),
        .init(title: "iOS 16 Ready", description: "Derm Diary is designed and ready for iOS 16.", image: "square.and.arrow.down"),
    ])
    
    static let version2 = Version(majorNumber: 1, minorNumber: 2, thirdNumber: 0, newFeatures: version2Features)
    
    static var version2Features: [NewFeature] {
#if os(macOS)
        [
            
            .init(title: "macOS Ventura Ready", description: "Derm Diary is designed and ready for macOS 13 Ventura.  Find the new photo picker, Continuity Camera, share sheet, and updated form styles throughout the app.", image: "square.and.arrow.down"),
            .init(title: "Shortcuts and Siri", description: "Derm Diary features next-level integration with the Shortcuts app!  18 actions to create, find, edit, open, and share your diaries and entries are ready to be integrated into your workflows.", image: "gearshape.2"),
            .init(title: "Diaries and Bookmarks", description: "Skin features have been renamed to skin diaries.  Add bookmarks to notable entries to view them separately.", image: "text.book.closed"),
        ]
#else
        [
            .init(title: "Apple Watch App", description: "Quickly add entries and share images while on-the-go.", image: "applewatch"),
            .init(title: "Text-Only Entries", description: "Add diary entries which don't contain an image.  E.g., updates from a doctor's appointment.", image: "text.book.closed"),
            .init(title: "Lock Screen Widgets", description: "Quickly access a diary and see when an entry was last added.", image: "lock.iphone"),
            .init(title: "iPadOS 16 Ready", description: "Derm Diary is designed and ready for iPadOS 16, including support for Stage Manager.", image: "square.and.arrow.down")
        ]
#endif
    }
    
    static let version3 = Version(majorNumber: 1, minorNumber: 3, thirdNumber: 0, newFeatures: [
        .init(title: "Derm Diary Unlimited Changes", description: .init(localized: "Create multiple diaries and change the app icon."), image: "infinity"),
        .init(title: "VoiceOver Improvements", description: nil, image: "speaker.wave.2.fill"),
        .init(title: "Updated Setup Experience for New Users", description: .init(localized: "Less text, clearer visuals, and the ability to purchase Derm Diary Unlimited."), image: "wand.and.stars"),
        .init(title: "Refreshed Diary Experience", description: .init(localized: "A redesigned diary details section, and entries are grouped by month."), image: "text.book.closed"),
        .init(title: "Bug Fixes", description: .init(localized: "More reliable Shortcuts actions and text/icon corrections on watchOS."), image: "hammer"),
    ])
    
    static let version4 = Version(majorNumber: 1, minorNumber: 4, thirdNumber: 0, newFeatures: [
        .init(title: "Diary Reminders", description: .init(localized: "Schedule notifications to remind you to update your diary regularly."), image: "bell"),
        .init(title: "Measurements", description: .init(localized: "Record the size of skin features and view trends on a chart."), image: "ruler"),
        .init(title: "New Design", description: .init(localized: "Browse your diaries with ease using the new interactive timeline, grid view, and clearer colors."), image: "star"),
        .init(title: "Export Backup", description: .init(localized: "Export diaries to a _.dermdiary_ archive file to create a backup of your data."), image: "archivebox"),
        .init(title: "Other Changes", description: .init(localized: "Larger widget sizes, multiple selection, data controls, Shortcuts updates, and bug fixes."), image: "ellipsis.circle")
    ])*/
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

extension Version: CaseIterable {
    public static var allCases: [Version] {
        []//[version1, version2, version3, version4].sorted()
    }
    
    public static var latest: Version {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let numbers = appVersion.split(separator: ".")
        let majorNumber = Int(numbers[0]) ?? 1
        let minorNumber = Int(numbers[1]) ?? 0
        let patchNumber: Int = numbers.count == 3 ? Int(numbers[2]) ?? 0 : 0
        return .init(majorNumber: majorNumber, minorNumber: minorNumber, thirdNumber: patchNumber)
    }
}

extension Version: Codable {
    private enum CodingKeys: CodingKey {
        case majorNumber, minorNumber, thirdNumber
    }
}

public struct NewFeature: Identifiable, Hashable {
    public let title: String
    public let description: AttributedString?
    public let image: String
    public var id: String { "\(title)" }
}
