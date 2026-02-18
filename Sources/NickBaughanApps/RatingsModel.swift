//
//  RatingsModel.swift
//  Chronoderm
//
//  Created by Nick Baughan on 09/06/2023.
//

import Foundation
import StoreKit
import OSLog

/// A way to track significant actions in the app.
///
/// Upon app launch, make sure you call ``markFirstLaunch()``.
@MainActor
public final class RatingsModel {
    
    /// Create a new RatingsModel to use throughout your app.  Store this as a global variable.
    ///
    /// - Parameter minimumSignificantActionCount: The minimum amount of times you wish an action to occur before prompting for a review.
    /// - Parameter minimumTimeSinceFirstLaunch: The minimum amount of time you wish to wait before prompting for a review after first launching the app.
    /// - Parameter minimumTimeBetweenRequests: The minimum amount of time you wish to wait before prompting for a review after the previous review.
    public init(minimumSignificantActionCount: Int, minimumTimeSinceFirstLaunch: TimeInterval, minimumTimeBetweenRequests: TimeInterval) {
        self.minimumSignificantActionCount = minimumSignificantActionCount
        self.minimumTimeSinceFirstLaunch = minimumTimeSinceFirstLaunch
        self.minimumTimeBetweenRequests = minimumTimeBetweenRequests
        self.markFirstLaunch()
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
    let defaults = UserDefaults.standard
    
    /// Set the earliest review date to the time set in ``init(minimumSignificantActionCount:minimumTimeSinceFirstLaunch:minimumTimeBetweenRequests:)``.
    ///
    /// Do this as soon as the app launches.
    public func markFirstLaunch() {
        if !defaults.bool(forKey: Self.appLaunchedPreviously) {
            defaults.set(true, forKey: Self.appLaunchedPreviously)
            Self.logger.info("App launched for the first time.")
            let earliestReviewDate = Date.now.addingTimeInterval(minimumTimeSinceFirstLaunch).timeIntervalSinceReferenceDate
            defaults.setValue(earliestReviewDate, forKey: Self.earliestReviewDate)
        }
        Self.logger.info("earliest review date: \(Date(timeIntervalSinceReferenceDate: self.defaults.double(forKey: Self.earliestReviewDate)))")
    }
    
    /// Ask for a review if criteria are met.
    ///
    /// Conditions for reviews:
    /// - Certain number of significant actions passed.
    /// - Certain amount of time passed.  1 month?
    /// - Returns: Whether to present a review request.
    ///
    /// - Note: If this method returns `true` and you present a review request, be sure to call ``reviewDidPresent()`` immediately after the request is made to update the next eligible review date.
    public func shouldPresentReview() -> Bool {
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
        defaults.setValue(Date.now.addingTimeInterval(minimumTimeBetweenRequests).timeIntervalSinceReferenceDate, forKey: Self.earliestReviewDate)
    }
    
    /// Mark a significant action as occurring without asking for a review.
    public func appendSignificantActionCount(_ count: Int = 1) {
        var significantActionCount = defaults.integer(forKey: Self.significantActionCountKey)
        significantActionCount += count
        Self.logger.info("Updating action count to \(significantActionCount)")
        defaults.setValue(significantActionCount, forKey: Self.significantActionCountKey)
    }
}

