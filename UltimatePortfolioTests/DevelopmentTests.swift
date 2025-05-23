//
//  DevelopmentTests.swift
//  UltimatePortfolioTests
//
//  Created by Jeff Xie on 5/20/25.
//

import CoreData
import XCTest
@testable import UltimatePortfolio

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() {
        dataController.createSampleData()
        
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 5, "There should be 5 sample tags.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 50, "There should be 550 sample issues.")
    }

    func testDeleteAllWorks() {
        dataController.createSampleData()
        
        dataController.deleteAll()
        
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 0, "There should be 0 sample tags.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 0, "There should be 0 sample issues.")
    }
    
    func testExampleTagZeroIssues() {
        let tag = Tag.example
        
        XCTAssertEqual(tag.issues?.count, 0, "The exmaple tag should have 0 issues.")
    }
    
    func testExampleIssueHighPriority() {
        let issue = Issue.example
        
        XCTAssertEqual(issue.priority, 2, "The example issue should have high priority.")
    }
}
