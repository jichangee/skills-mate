import AppKit
import SwiftUI
import XCTest
@testable import SkillsMateApp

@MainActor
final class MarketplaceViewTests: XCTestCase {
    func testMarketplaceViewBodyBuilds() {
        let store = SkillsStore()
        let view = MarketplaceView()
            .environmentObject(store)

        let hostingView = NSHostingView(rootView: view)
        XCTAssertNotNil(hostingView)
    }
}
