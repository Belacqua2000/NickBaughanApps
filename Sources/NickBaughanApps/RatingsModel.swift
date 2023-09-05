//
//  RatingsModel.swift
//  Chronoderm
//
//  Created by Nick Baughan on 09/06/2023.
//

import Foundation
import StoreKit
import OSLog

public struct RatingsModel: Sendable {
    static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Ratings")
    static let lastReviewVersionKey = "lastReviewVersion"
    static let earliestReviewDate = "minimumReviewDate"
    static let appLaunchedPreviously = "appLaunchedPreviously"
    static let dayOneDate = "dayOneDate"
    static let significantActionCountKey = "significantActionCount"
    
    static let allKeys = [lastReviewVersionKey, earliestReviewDate, appLaunchedPreviously, dayOneDate, significantActionCountKey]
    
    /// Set the earliest review date to 24 hours after today.
    public static func markFirstLaunch() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: Self.appLaunchedPreviously) {
            defaults.set(true, forKey: Self.appLaunchedPreviously)
            logger.info("App launched first time")
            defaults.setValue(Date.now.addingTimeInterval(TimeInterval(86_400)).timeIntervalSinceReferenceDate, forKey: Self.earliestReviewDate)
        }
    }
    
    /// Check whether to present a review.
    ///
    /// Conditions for reviews:
    /// - Certain number of significant actions passed.
    /// - Not the current app version
    /// - Certain amount of time passed.  1 month?
    /// - Returns: Whether to present a review request.
    public static func shouldPresentReview() -> Bool {
        appendSignificantActionCount()
        let defaults = UserDefaults.standard
        let lastReviewVersion = try? JSONDecoder().decode(Version.self, from: defaults.data(forKey: Self.lastReviewVersionKey) ?? Data())
        let earliestReviewDate = Date(timeIntervalSinceReferenceDate: defaults.double(forKey: Self.earliestReviewDate))
        logger.info("Earliest review date = \(earliestReviewDate.formatted())")
        if defaults.integer(forKey: Self.significantActionCountKey) >= 5 && lastReviewVersion ?? .version1 < .latest && earliestReviewDate < .now {
            updateReview()
            logger.info("Review should present")
            return true
        } else {
            logger.info("Review should not present")
            return false
        }
    }
    
    /// Update UserDefaults with the details of the current review.
    private static func updateReview() {
        logger.info("Updating review condition.")
        let defaults = UserDefaults.standard
        defaults.setValue(try? JSONEncoder().encode(Version.latest), forKey: Self.lastReviewVersionKey)
        defaults.setValue(Date.now.addingTimeInterval(TimeInterval(2_678_400)).timeIntervalSinceReferenceDate, forKey: Self.earliestReviewDate)
    }
    
    private static func appendSignificantActionCount() {
        var significantActionCount = UserDefaults.standard.integer(forKey: Self.significantActionCountKey)
        significantActionCount += 1
        logger.info("Updating action count to \(significantActionCount)")
        UserDefaults.standard.setValue(significantActionCount, forKey: Self.significantActionCountKey)
    }
}
