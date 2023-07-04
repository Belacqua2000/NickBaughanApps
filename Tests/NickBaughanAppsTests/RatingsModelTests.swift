import XCTest
@testable import NickBaughanApps

final class RatingsModelTests: XCTestCase {
    func testConditionsSet() throws {
        RatingsModel.markFirstLaunch()
        XCTAssertFalse(RatingsModel.shouldPresentReview())
    }
    
//    func testShouldPresentReviewCount() throws {
//        for _ in 0..<5 {
//            let _ = RatingsModel.shouldPresentReview()
//        }
//
//        XCTAssertEqual(RatingsModel.significantActionCountKey, "5")
//    }
}
