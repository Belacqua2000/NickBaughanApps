import XCTest
@testable import NickBaughanApps

final class RatingsModelTests: XCTestCase {
    
    override class func setUp() {
        let ud = UserDefaults.standard
        RatingsModel.allKeys.forEach {
            ud.removeObject(forKey: $0)
        }
    }
    
//    func testConditionsSet() throws {
//        RatingsModel.markFirstLaunch()
//        XCTAssertFalse(RatingsModel.shouldPresentReview())
//    }
    
    func testShouldPresentReviewCount() throws {
        for _ in 0..<5 {
            let _ = RatingsModel.shouldPresentReview()
        }
        
        let actionCount = UserDefaults.standard.integer(forKey: RatingsModel.significantActionCountKey)

        XCTAssertEqual(actionCount, 5, "Found the key \(actionCount)")
    }
}
