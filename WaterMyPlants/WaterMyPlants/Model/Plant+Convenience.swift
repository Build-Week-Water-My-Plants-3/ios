//
//  Plant+Convenience.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import Foundation
import CoreData

extension Plant {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case nickname = "nickname"
        case species = "species"
        case h2oFrequency = "h2oFrequency"
        case image = "image"
    }
    
    // need to add a convenience initializer
    
    // need to add a "representation" convenience initializer
    
    // need to add a "userRepresentation" property of type "UserRepresentation"  (see example project)
}
