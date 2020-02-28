//
//  ModelRepresentation.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    var password: String
    var phoneNumber: String
    var username: String
}

struct PlantRepresentation: Codable {
    var identifier: String
    var nickname: String
    var species: String
    var h2oFrequency: Int
    var lastWatered: Date
    var image: Data?
}
