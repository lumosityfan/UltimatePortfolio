//
//  PerformanceTests.swift
//  UltimatePortfolioTests
//
//  Created by Jeff Xie on 5/22/25.
//

import Testing
import CoreData
import XCTest
@testable import UltimatePortfolio

class PerformanceTests: BaseTestCase {
    func testAwardCalculationPerformance() {
        // Create a significant amount of test data
        for _ in 1...100 {
            dataController.createSampleData()
        }
        
        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards.")
        
        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }

}
