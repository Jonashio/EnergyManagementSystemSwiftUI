//
//  EnergyManagementSystemSwiftUIUITests.swift
//  EnergyManagementSystemSwiftUIUITests
//
//  Created by Jonashio on 3/8/22.
//

import XCTest

class DashboViewUITest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func testOpenAndCloseDetailView() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Dashbo is showing
        XCTAssert(app.staticTexts["Dashbo Status"].exists)
        // Go to Detail
        XCTAssert(app.buttons["TapDetail"].waitForExistence(timeout: 2))
        app.buttons["TapDetail"].firstMatch.tap()
        // Check Detail
        XCTAssert(app.staticTexts["Historic data"].waitForExistence(timeout: 2))
        // Close Detail
        app.buttons["Dashbo Status"].tap()
        // Check if the detail is really close
        XCTAssertFalse(app.buttons["Historic data"].waitForExistence(timeout: 0.5))
    }
}
