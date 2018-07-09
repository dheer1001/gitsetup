//
//  NetSCANUITests.swift
//  NetSCANUITests
//
//  Created by User on 9/15/16.
//  Copyright © 2016 User. All rights reserved.
//

import XCTest

class NetSCANUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        
        let elementsQuery = app.scrollViews.otherElements
        
        elementsQuery.textFields["Service ID"].tap()
        elementsQuery.textFields["Service ID"].typeText("123")
        
        elementsQuery.textFields["Airline"].tap()
        elementsQuery.textFields["Airline"].typeText("abc")
        
        elementsQuery.textFields["Airport Code"].tap()
        elementsQuery.textFields["Airport Code"].typeText("xyz")

        app.buttons["START"].tap()
        
        let internetOnlineButton    = app.buttons["Internet Online"]
        let internetOfflineButton   = app.buttons["Internet Offline"]
        let scannerConnectButton    = app.buttons["Scanner Connect"]
        let scannerDisconnectButton = app.buttons["Scanner Disconnect"]
        let setLocationButton       = app.buttons["Set Location"]
        let startTimerButton        = app.buttons["Start Timer"]
        
        internetOnlineButton.tap()
        sleep(1)
        internetOfflineButton.tap()
        sleep(1)
        scannerConnectButton.tap()
        sleep(1)
        scannerDisconnectButton.tap()
        sleep(1)
        setLocationButton.tap()
        sleep(1)
        startTimerButton.tap()
        sleep(8)
        startTimerButton.tap()
        sleep(10)
    }
    
    func testTwo() {
        
    }
    
}
