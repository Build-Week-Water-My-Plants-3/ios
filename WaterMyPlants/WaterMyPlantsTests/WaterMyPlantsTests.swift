//
//  WaterMyPlantsTests.swift
//  WaterMyPlantsTests
//
//  Created by Craig Swanson on 3/4/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import XCTest
import CoreData
@testable import WaterMyPlants

class WaterMyPlantsTests: XCTestCase {
    
    func testLogInExistingUser() {
        let userController = UserController()
        let user = User(password: "craigTest", phoneNumber: "12345", username: "craigTest")
        let userRep = user.userRepresentation
        var resultError: Error?
        
        let logInExpectation = expectation(description: "LogIn Existing User")
        userController.signIn(with: userRep!) { (possibleError) in
            logInExpectation.fulfill()
            if possibleError != nil {
                resultError = possibleError
            }
        }
        wait(for: [logInExpectation], timeout: 2)
        XCTAssertNil(resultError)
        
    }
    
    func testExistingUser() {
        let user = User(password: "craigTest", phoneNumber: "12345", username: "craigTest")
        let plantController = PlantController()
        var error: Error?
        
        let userExpectation = expectation(description: "Wait for user results")
        
        plantController.fetchPlantsFromServer(user: user) { possibleError in
            userExpectation.fulfill()
            if let returnedError = possibleError {
                error = returnedError
                return
            }
        }
        wait(for: [userExpectation], timeout: 2)
        
        XCTAssertNil(error)
        
    }
    
    func testNonExistingUser() {
        let user = User(password: "q1q1q1q1", phoneNumber: "23455", username: "q1q1q1q1")
        let plantController = PlantController()
        
        XCTAssertNotNil(plantController.fetchPlantsFromServer(user: user))
    }
}
