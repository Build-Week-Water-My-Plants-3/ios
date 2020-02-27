//
//  UserController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserController {
    
    // Linking to firebase database for testing networking code
    private let baseURL = URL(string: "https://w4t3rmypl4nt5.firebaseio.com/")!
    
    // MARK: - Register New User
    func registerUser(with user: UserRepresentation, completion: @escaping (Error?) -> Void) {
        
    }
    
    // MARK: - Log In Existing User
    func logIn(with user: UserRepresentation, completion: @escaping (Error?) -> Void) {
        
    }
}
