import Testing
import Foundation
@testable import NickBaughanApps

struct RatingsModelTests {
    
    init() {
        let ud = UserDefaults.standard
        RatingsModel.allKeys.forEach {
            ud.removeObject(forKey: $0)
        }
    }
    
    @Test
    func testShouldPresentReviewCount() async throws {
        let model = RatingsModel(minimumSignificantActionCount: 5, minimumTimeSinceFirstLaunch: 84_600, minimumTimeBetweenRequests: 84_600*28)
        for _ in 0..<5 {
            let _ = await model.shouldPresentReview()
        }
        
        let actionCount = UserDefaults.standard.integer(forKey: RatingsModel.significantActionCountKey)
        #expect(actionCount == 5, "Found the key \(actionCount)")
    }
}
