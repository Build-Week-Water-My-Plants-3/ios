//
//  User+Convenience.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    // these will change when we get the api endpoints.
    enum CodingKeys: String, CodingKey {
        case identifier = "identifer"
        case password = "password"
        case phoneNumber = "phoneNumber"
        case username = "username"
    }
    
    // need to add a convenience initializer
    
    // need to add a "representation" convenience initializer
    
    // need to add a "userRepresentation" property of type "UserRepresentation"  (see example project)
}
