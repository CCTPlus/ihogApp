//
//  iHogUITestsScreenShots.swift
//  iHogUITestsScreenShots
//
//  Created by Jay Wilson on 2/1/21.
//

import XCTest

class iHogUITestsScreenShots: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        setupSnapshot(app)

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.navigationBars["Device Settings"].buttons["Back"].tap()
        snapshot("settings_device")
        let tablesQuery = app.tables
        snapshot("navigationAll")
        tablesQuery.buttons["TS: folklore"].tap()
        
        let tabBar = app.tabBars["Tab Bar"]
        snapshot("show_groups_palettes")
        tabBar.buttons["esim"].tap()
//        snapshot("puntpage")
        tabBar.buttons["play.rectangle"].tap()
        snapshot("show_scenes_lists")
        tabBar.buttons["wand.and.rays"].tap()
        app.navigationBars["TS: folklore"].buttons["Back"].tap()
        tablesQuery.buttons["Programming"].tap()
        snapshot("hardware_programming")
        app.scrollViews.otherElements.buttons["Kind Keys & Encoders"].tap()
        snapshot("hardware_encoders")
        app.buttons["Close"].tap()
        app.navigationBars["Command line text"].buttons["Back"].tap()
        tablesQuery.buttons["Playback"].tap()
        snapshot("hardware_playback")
        app.navigationBars["_TtGC7SwiftUIP13$7fff57adc30428DestinationHosting"].buttons["Back"].tap();
        tablesQuery.cells["Show Settings"].children(matching: .other).element(boundBy: 0).tap()
        snapshot("settings_show")
        app.navigationBars["Show Settings"].buttons["Back"].tap()
        
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
