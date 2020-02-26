//
//  ModelRepresentation.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    var identifier: String
    var password: String
    var phoneNumber: String
    var username: String
}

struct PlantRepresentation: Codable {
    var id: Int
    var nickname: String
    var species: String
    var h2oFrequency: Int
    var image: Data
}
