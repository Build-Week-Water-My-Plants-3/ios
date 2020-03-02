//
//  PlantController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PlantController {
    
    // Linking to firebase database for testing networking code
    private let baseURL = URL(string: "https://w4t3rmypl4nt5.firebaseio.com/")!
    
    // MARK: - Put Plant to Server
    func put(plant: Plant, completion: @escaping (Error?) -> Void = {_ in }) {
        guard let identifier = plant.identifier else { return }
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue

        do {
            guard var representation = plant.plantRepresentation else {
                print("Error creating PlantRepresentation in PUT")
                completion(nil)
                return
            }

            // we might possibly need to make another object to post to the server depending on what the backend provides.
            // for example, we might need to make a "plantToPostToServer" that has slightly different parameters than our current "PlantRepresentation" provides.

            representation.identifier = identifier.uuidString
            plant.identifier = identifier
            try CoreDataStack.shared.save()
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
            request.httpBody = try jsonEncoder.encode(representation)
        } catch {
            print("Error encoding task \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { _, _, possibleError in
            guard possibleError == nil else {
                print("Error PUTing plant to the server: \(possibleError)")
                completion(possibleError)
                return
            }
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: .plantSavedToServer, object: nil)
            
            completion(nil)
        }.resume()
    }

    // MARK: - Fetch Plant From Server
    func fetchPlantsFromServer(completion: @escaping (Error?) -> Void = {_ in }) {
        let requestURL = baseURL.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestURL) { possibleData, _, possibleError in
            guard possibleError == nil else {
                print("Error fetching plants: \(possibleError)")
                completion(possibleError)
                return
            }

            guard let data = possibleData else {
                print("No data return by data task in fetch")
                completion(NSError())
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                var plants: [PlantRepresentation] = []
                plants = Array(try jsonDecoder.decode([String: PlantRepresentation].self, from: data).values)

                try self.updatePlants(with: plants)

            } catch {
                print("Error decoding plants: \(error)")
                completion(error)
                return
            }
        }.resume()
    }

    // MARK: - Update Core Data
    // Assumes that the data on the server is correct and replaces core data with server data
    func updatePlants(with representations: [PlantRepresentation]) throws {
        let plantsWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = plantsWithID.compactMap { $0.identifier }
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, plantsWithID))
        
        var plantsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        let moc = CoreDataStack.shared.container.newBackgroundContext()
        
        moc.perform {
            do {
                let existingPlants = try moc.fetch(fetchRequest)
                
                for plant in existingPlants {
                    guard let id = plant.identifier?.uuidString,
                        let representation = representationsByID[id] else {
                            moc.delete(plant)
                            continue
                    }
                    
                    self.update(plant: plant, representation: representation)
                    
                    plantsToCreate.removeValue(forKey: id)
                }
                
                for representation in plantsToCreate.values {
                    Plant(plantRepresentation: representation, context: moc)
                }
            } catch {
                print("Error fetching plants for identifiers: \(error)")
            }
        }
        try CoreDataStack.shared.save(context: moc)
    }
    
    func update(plant: Plant, representation: PlantRepresentation) {
        plant.identifier = UUID(uuidString: representation.identifier)
        plant.species = representation.species
        plant.nickname = representation.nickname
        plant.h2oFrequency = Int32(representation.h2oFrequency)
        plant.lastWatered = representation.lastWatered
        plant.image = representation.image
    }
    
    // MARK: - Update Existing Plant
    // Called from detail view controller when making changes
    func updateExistingPlant(for plant: Plant) {
        put(plant: plant)
        do {
            try CoreDataStack.shared.save()
        } catch {
            print("Error updating existing plant")
        }
    }
    
    // MARK: - Delete Existing Plant
    // first deletes from core data and then calls method to delete from server
    func deletePlant(for plant: Plant) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(plant)
        deletePlantFromServer(plant)
        do {
            try CoreDataStack.shared.save()
        } catch {
            print("Error deleting plant from Core Data")
        }
    }
    
    func deletePlantFromServer(_ plant: Plant, completion: @escaping (Error?) -> Void = {_ in }) {
        guard let identifier = plant.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { _, _, possibleError in
            guard possibleError == nil else {
                print("Error deleting plant from server: \(possibleError!)")
                completion(possibleError)
                return
            }
            completion(nil)
        }.resume()
    }
}
