//
//  SwiftCalcUITests.swift
//  SwiftCalcUITests
//
//  Created by mk on 12/10/23.
//

import XCTest

final class SwiftCalcUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // ...
    }

    func testPressMemoryPlusAtAppStartShowZeroInDisplay() throws {
        let app = XCUIApplication()
        app.launch()
		
		let memoryButton = app.buttons["M+"]
		memoryButton.tap()
		
		let display = app.staticTexts["display"]
		let displayText = display.label
		XCTAssert(displayText == "0")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
	
	func testAddingTwoDigits() {
		let app = XCUIApplication()
		app.launch()
		
		let threeButton = app.buttons["3"]
		threeButton.tap()
		
		let addButton = app.buttons["+"]
		addButton.tap()
		
		let fiveButton = app.buttons["5"]
		fiveButton.tap()
		
		let equalButton = app.buttons["="]
		equalButton.tap()
		
		let display = app.staticTexts["display"]
		let displayText = display.label
		XCTAssertEqual(displayText, "8.0")
	}
	
	#if targetEnvironment(iOS) || targetEnvironment(simulator)
	func testSwipeToClearMemory() {
		let app = XCUIApplication()
		app.launch()
		
		let threeButton = app.buttons["3"]
		threeButton.tap()
		
		let fiveButton = app.buttons["5"]
		fiveButton.tap()
		
		let memoryButton = app.buttons["M+"]
		memoryButton.tap()
		
		let memoryDisplay = app.staticTexts["memoryDisplay"]
		XCTAssert(memoryDisplay.exists)
		
		memoryDisplay.swipeLeft()
		XCTAssertFalse(memoryDisplay.exists)
	}
	#endif
}
