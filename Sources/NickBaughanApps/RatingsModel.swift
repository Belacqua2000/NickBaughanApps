//
//  RatingsModel.swift
//  Chronoderm
//
//  Created by Nick Baughan on 09/06/2023.
//

import Foundation
import StoreKit
import OSLog

@available(iOS 17, macOS 14, watchOS 10, tvOS 17, *)
@Observable
public final class RatingsModel: Sendable {
    
    /// Create a new RatingsModel to use throughout your app.
    ///
    /// - Parameter minimumSignificantActionCount: The minimum amount of times you wish an action to occur before prompting for a review.
    /// - Parameter minimumTimeSinceFirstLaunch: The minimum amount of time you wish to wait before prompting for a review after first launching the app.
    /// - Parameter minimumTimeBetweenRequests: The minimum amount of time you wish to wait before prompting for a review after the previous review.
    public init(minimumSignificantActionCount: Int, minimumTimeSinceFirstLaunch: TimeInterval, minimumTimeBetweenRequests: TimeInterval) {
        self.minimumSignificantActionCount = minimumSignificantActionCount
        self.minimumTimeSinceFirstLaunch = minimumTimeSinceFirstLaunch
        self.minimumTimeBetweenRequests = minimumTimeBetweenRequests
    }
    
    static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Ratings")
    static let earliestReviewDate = "minimumReviewDate"
    static let appLaunchedPreviously = "appLaunchedPreviously"
    static let dayOneDate = "dayOneDate"
    static let significantActionCountKey = "significantActionCount"
    
    static let allKeys = [earliestReviewDate, appLaunchedPreviously, dayOneDate, significantActionCountKey]
    
    let minimumSignificantActionCount: Int
    let minimumTimeSinceFirstLaunch: TimeInterval
    let minimumTimeBetweenRequests: TimeInterval
    
    /// Set the earliest review date to 24 hours after today.
    public func markFirstLaunch() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: Self.appLaunchedPreviously) {
            defaults.set(true, forKey: Self.appLaunchedPreviously)
            Self.logger.info("App launched first time.")
            let earliestReviewDate = Date.now.addingTimeInterval(minimumTimeSinceFirstLaunch).timeIntervalSinceReferenceDate
            defaults.setValue(earliestReviewDate, forKey: Self.earliestReviewDate)
        }
        Self.logger.info("earliest review date: \(Date(timeIntervalSinceReferenceDate: defaults.double(forKey: Self.earliestReviewDate)))")
    }
    
    /// Mark a significant action as occurring and ask for a review if criteria are met.
    ///
    /// Conditions for reviews:
    /// - Certain number of significant actions passed.
    /// - Certain amount of time passed.  1 month?
    /// - Returns: Whether to present a review request.
    public func shouldPresentReview() -> Bool {
        appendSignificantActionCount()
        let defaults = UserDefaults.standard
        let earliestReviewDate = Date(timeIntervalSinceReferenceDate: defaults.double(forKey: Self.earliestReviewDate))
        let significantActionCount = defaults.integer(forKey: Self.significantActionCountKey)
        Self.logger.info("Earliest review date = \(earliestReviewDate.formatted())")
        Self.logger.info("Significant Action Count: \(significantActionCount)")
        if significantActionCount >= minimumSignificantActionCount && earliestReviewDate < .now {
            Self.logger.info("Review should present")
            return true
        } else {
            Self.logger.info("Review should not present")
            return false
        }
    }
    
    /// Update UserDefaults with the details of the current review.
    public func reviewDidPresent() {
        Self.logger.info("Updating review condition.")
        let defaults = UserDefaults.standard
        defaults.setValue(Date.now.addingTimeInterval(minimumTimeBetweenRequests).timeIntervalSinceReferenceDate, forKey: Self.earliestReviewDate)
    }
    
    /// Mark a significant action as occurring without asking for a review.
    public func appendSignificantActionCount() {
        var significantActionCount = UserDefaults.standard.integer(forKey: Self.significantActionCountKey)
        significantActionCount += 1
        Self.logger.info("Updating action count to \(significantActionCount)")
        UserDefaults.standard.setValue(significantActionCount, forKey: Self.significantActionCountKey)
    }
}
