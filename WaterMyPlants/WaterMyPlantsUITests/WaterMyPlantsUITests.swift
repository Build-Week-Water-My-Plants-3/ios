//
//  WaterMyPlantsUITests.swift
//  WaterMyPlantsUITests
//
//  Created by Craig Swanson on 3/5/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import XCTest

class WaterMyPlantsUITests: XCTestCase, UITextFieldDelegate {
    
    private var app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testRegisterFromLandingPage() {
        
        // Note: This will display "Sign Up Successful" for the first usage and "Sign Up Not Successful" for the subsequent useages.
        // Reminder: Hardware keyboard must be turned off in the simulator.
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.buttons["LandingSignUpButton"]/*[[".buttons[\"Sign Up\"]",".buttons[\"LandingSignUpButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let username = app.textFields["RegistrationUsername"]
        username.tap()
        username.typeText("BarleyCorn3")
        
        let password = app.secureTextFields["RegistrationPassword"]
        XCTAssert(password.exists)
        password.tap()
        password.typeText("password")

        let phonenumber = app.textFields["RegistrationPhoneNumber"]
        phonenumber.tap()
        phonenumber.typeText("7775553333")
        app.keyboards.buttons["Return"].tap()
        app.tap()
        app/*@START_MENU_TOKEN@*/.buttons["RegistrationSignUpButton"]/*[[".buttons[\"Sign Up\"]",".buttons[\"RegistrationSignUpButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        addUIInterruptionMonitor(withDescription: "") { (alert) -> Bool in
            let alertText = "Sign Up Successful"
            if alert.label.contains(alertText) {
                XCTAssertTrue(alert.exists)
            }
            return true
        }
    }
    
    func testRegisterDuplicateFromLandingPage() {
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.buttons["LandingSignUpButton"]/*[[".buttons[\"Sign Up\"]",".buttons[\"LandingSignUpButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let username = app.textFields["RegistrationUsername"]
        username.tap()
        username.typeText("BarleyCorn3")
        
        let password = app.secureTextFields["RegistrationPassword"]
        XCTAssert(password.exists)
        password.tap()
        password.typeText("password")

        let phonenumber = app.textFields["RegistrationPhoneNumber"]
        phonenumber.tap()
        phonenumber.typeText("7775553333")
        app.keyboards.buttons["Return"].tap()
        app.tap()
        app/*@START_MENU_TOKEN@*/.buttons["RegistrationSignUpButton"]/*[[".buttons[\"Sign Up\"]",".buttons[\"RegistrationSignUpButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        addUIInterruptionMonitor(withDescription: "") { (alert) -> Bool in
            let alertText = "Sign Up Not Successful"
            if alert.label.contains(alertText) {
                XCTAssertTrue(alert.exists)
            }
            return true
        }
    }
    
    func testSignInFromLandingPage() {
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.buttons["LandingLogInButton"]/*[[".buttons[\"Login Here\"]",".buttons[\"LandingLogInButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let username = app.textFields["SignInUsername"]
        username.tap()
        username.typeText("BarleyCorn3")
        
        let password = app.secureTextFields["SignInPassword"]
        password.tap()
        password.typeText("password")
        app.keyboards.buttons["Return"].tap()
        app.tap()
        app/*@START_MENU_TOKEN@*/.buttons["SignInButton"]/*[[".buttons[\"Sign In\"]",".buttons[\"SignInButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.navigationBars["Plants"].exists)
    }
    
    // Creating a new plant gives a successful alert
    func testTapNewPlant() {
        // In Landing Screen
        app/*@START_MENU_TOKEN@*/.buttons["LandingLogInButton"]/*[[".buttons[\"Login Here\"]",".buttons[\"LandingLogInButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // In UserSignInViewController
        let username = app.textFields["SignInUsername"]
            username.tap()
        username.typeText("BarleyCorn3")
        
        let password = app.secureTextFields["SignInPassword"]
        password.tap()
        password.typeText("password")
        app.keyboards.buttons["Return"].tap()
        app.tap()
        app/*@START_MENU_TOKEN@*/.buttons["SignInButton"]/*[[".buttons[\"Sign In\"]",".buttons[\"SignInButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // In UserPlantsViewController
        app.navigationBars["Plants"].buttons["Add"].tap()
        XCTAssertTrue(app.buttons["Choose Photo"].exists)
    }
    
    func testCreateNewPlant() {
        // In Landing Screen
        app/*@START_MENU_TOKEN@*/.buttons["LandingLogInButton"]/*[[".buttons[\"Login Here\"]",".buttons[\"LandingLogInButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // In UserSignInViewController
        let username = app.textFields["SignInUsername"]
        username.tap()
        username.typeText("BarleyCorn3")
        
        let password = app.secureTextFields["SignInPassword"]
        password.tap()
        password.typeText("password")
        app.keyboards.buttons["Return"].tap()
        app.tap()
        app/*@START_MENU_TOKEN@*/.buttons["SignInButton"]/*[[".buttons[\"Sign In\"]",".buttons[\"SignInButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // In UserPlantsViewController
        app.navigationBars["Plants"].buttons["Add"].tap()
        
        // In EditPlantViewController
        let nickname = app.textFields["Nickname"]
        nickname.tap()
        nickname.typeText("Ralphie")
        let species = app.textFields["Species"]
        species.tap()
        species.typeText("Petunia")
        let watering = app.textFields["Days between Watering"]
        watering.tap()
        watering.typeText("5")
        app.tap()
        app.toolbars["Toolbar"].buttons["Save"].tap()
        XCTAssert(app.alerts["New Plant Added"].exists)
    }
}
