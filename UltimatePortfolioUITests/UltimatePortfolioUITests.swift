//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by Jeff Xie on 5/22/25.
//

import XCTest

extension XCUIElement {
    func clear() {
        guard let stringValue = self.value as? String else {
            XCTFail("Failed to clear text in XCUIElement.")
            return
        }
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}

final class UltimatePortfolioUITests: XCTestCase {

    var app: XCUIApplication!
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    @MainActor
    func testAppStartsWithNavigationBar() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(app.navigationBars.element.exists, "There should be a navigation bar when the app launches.")
    }
    
    func testAppHasBasicButtonsOnLaunch() throws {
        XCTAssertTrue(app.navigationBars.buttons["Filters"].exists, "There should be a Filters button launch.")
        XCTAssertTrue(app.navigationBars.buttons["Filter"].exists, "There should be a Filter button launch.")
        XCTAssertTrue(app.navigationBars.buttons["New Issue"].exists, "There should be a New Issue button launch.")
    }
    
    func testNoIssuesAtStart() {
        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")
    }
    
    func testCreatingAndDeletingIssues() {
        for tapCount in 1...5 {
            app.buttons["New Issue"].tap()
            app.buttons["Issues"].tap()
            
            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }
        
        for tapCount in (0...4).reversed() {
            app.cells.firstMatch.swipeLeft()
            app.buttons["Delete"].tap()
            
            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }
    }
    
    func testEditingIssueTitleUpdatesCorrectly() {
        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")
        
        app.buttons["New Issue"].tap()
        
        // more code to come
        app.textFields["Enter the issue title here"].tap()
        
        app.textFields["Enter the issue title here"].clear()
        app.typeText("My New Issue")
        
        app.buttons["Issues"].tap()
        XCTAssertTrue(app.buttons["My New Issue"].exists, "A My New Issue cell should now exist.")
    }
    
    func testEditingIssuePriorityShowsIcon() {
        app.buttons["New Issue"].tap()
        app.buttons["Priority, Medium"].tap()
        app.buttons["High"].tap()
        
        app.buttons["Issues"].tap()
        
        let identifier = "New issue High Priority"
        XCTAssert(app.images[identifier].exists, "A high-priority issue needs an icon next to it.")
    }
    
    func testAllAwardsShowLockedAlert() {
        app.buttons["Filters"].tap()
        app.buttons["Show awards"].tap()
        
        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            if app.windows.element.frame.contains(award.frame) == false {
                app.swipeUp()
            }
            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists, "There should be a Locked alert showing for awards.")
            app.buttons["OK"].tap()
            
        }
    }
}
