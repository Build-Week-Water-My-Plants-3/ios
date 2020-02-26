//
//  Bearer.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import Foundation

// used to get the authorization token from the API
struct Bearer: Codable {
    let token: String
}
