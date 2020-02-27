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

            representation.identifier = identifier.uuidString
            plant.identifier = identifier
            try CoreDataStack.shared.save()
            request.httpBody = try JSONEncoder().encode(representation)
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
            completion(nil)
        }.resume()
    }

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
                var plants: [PlantRepresentation] = []
                plants = Array(try JSONDecoder().decode([String: PlantRepresentation].self, from: data).values)

                try self.updatePlants(with: plants)

            } catch {
                print("Error decoding plants: \(error)")
                completion(error)
                return
            }
        }.resume()
    }

    func updatePlants(with representations: [PlantRepresentation]) throws {
        
    }
}
