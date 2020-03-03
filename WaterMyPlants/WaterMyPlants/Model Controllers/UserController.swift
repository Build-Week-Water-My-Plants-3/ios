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
    private let baseURL = URL(string: "https://watermyplants-6308f.firebaseio.com/user")!
    
    var bearer: Bearer?
    var match: Bool = false
    
    
    // MARK: - Register New User
    func signUp(with user: UserRepresentation, completion: @escaping (Error?) -> Void) {
        let registerUserURL = baseURL.appendingPathComponent(user.username).appendingPathExtension("json")
        var request = URLRequest(url: registerUserURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
//        request.setValue("application/json", forHTTPHeaderField: "content-Type")
//        let jsonEncoder = JSONEncoder()
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
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

        let logInURL = baseURL
            .appendingPathComponent(user.username)
            .appendingPathComponent("password")
            .appendingPathExtension("json")
        
        var request = URLRequest(url: logInURL)
        request.httpMethod = HTTPMethod.get.rawValue

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
                let password = try decoder.decode(String.self, from: data)
                print("firebase password: \(password)")
                print("text field password: \(user.password)")
                
                if user.password == password {
                    print("We HAVE a match!!!!!!!!!!!!")
                    self.match = true
                } else {
                    print("We DON'T have a match!!!!!!!!!!!!")
                    self.match = false
                }
                
            } catch {
                print("Erorr decoding password object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        } .resume()
    }
}
