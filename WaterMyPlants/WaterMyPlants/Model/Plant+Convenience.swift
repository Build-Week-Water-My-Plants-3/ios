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
        case identifier = "identifier"
        case nickname = "nickname"
        case species = "species"
        case h2oFrequency = "h2oFrequency"
        case image = "image"
    }

    var plantRepresentation: PlantRepresentation? {
        guard let nickname = nickname,
            let species = species,
            let lastWatered = lastWatered else { return nil }
        return PlantRepresentation(identifier: UUID().uuidString,
                                   nickname: nickname,
                                   species: species,
                                   h2oFrequency: Int(h2oFrequency),
                                   lastWatered: lastWatered,
                                   image: image)
    }

    // need to add a convenience initializer
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        nickname: String,
                                        species: String,
                                        h2oFrequency: Int,
                                        lastWatered: Date = Date(),
                                        image: Data?,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.nickname = nickname
        self.species = species
        self.h2oFrequency = Int32(h2oFrequency)
        self.lastWatered = lastWatered
        self.image = image
    }

    // need to add a "representation" convenience initializer
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext) {

        self.init(identifier: UUID(uuidString: plantRepresentation.identifier) ?? UUID(),
                  nickname: plantRepresentation.nickname,
                  species: plantRepresentation.species,
                  h2oFrequency: plantRepresentation.h2oFrequency,
                  lastWatered: plantRepresentation.lastWatered,
                  image: plantRepresentation.image)
    }
}
