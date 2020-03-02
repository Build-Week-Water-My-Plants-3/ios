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
    private let baseURL = URL(string: "https://watermyplants-6308f.firebaseio.com/")!
    
    var bearer: Bearer?
    
    // MARK: - Register New User
    func signUp(with user: UserRepresentation, completion: @escaping (Error?) -> Void) {
        // get and change endpoint!!!
        let registerUserURL = baseURL.appendingPathComponent(user.username).appendingPathExtension("json")
        var request = URLRequest(url: registerUserURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        // get and change endpoints!!!
//        request.setValue("application/json", forHTTPHeaderField: "content-Type")
        
//        let jsonEncoder = JSONEncoder()
        do {
//            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = try JSONEncoder().encode(user)
//            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(error)
                return
            }
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 200 {
//                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
//                return
//            }
            completion(nil)
        }.resume()
    }
    
    // MARK: - Log In Existing User
    func signIn(with user: UserRepresentation, completion: @escaping (Error?) -> Void) {
        // get and change endpoints!!!
        let logInURL = baseURL
        
        var request = URLRequest(url: logInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        // get and change endpoints!!!
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            guard let data = data else {
                completion(NSError())
                return
            }
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Erorr decoding bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        } .resume()
    }
}
