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
    var passwordMatch: Bool = false
    var usernameMatch: Bool = false
    var phoneNumber: String = ""
    
    // MARK: - Register New User
    func signUp(with user: UserRepresentation, completion: @escaping (Error?) -> Void) {
        
        let getUserURL = baseURL
            .appendingPathComponent(user.username)
            .appendingPathComponent("username")
            .appendingPathExtension("json")
        var getUserRequest = URLRequest(url: getUserURL)
        getUserRequest.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: getUserRequest) { data, response, error in
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
                let username = try decoder.decode(String.self, from: data)
                
                if user.username == username {
                    print("\(username) already exists")
                    self.usernameMatch = true
                }
            } catch {
                print("Username \(user.username) does not exist which is great!! Now we can create a new User or there was an error docoding username: \(error)")
                
                let registerUserURL = self.baseURL
                    .appendingPathComponent(user.username)
                    .appendingPathExtension("json")
                var request = URLRequest(url: registerUserURL)
                request.httpMethod = HTTPMethod.put.rawValue
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
                    completion(nil)
                }.resume()
                completion(error)
                return
            }
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
                    print("We HAVE a match!")
                    self.passwordMatch = true
                    
                    DispatchQueue.main.async {
                        let notificationCenter = NotificationCenter.default
                        notificationCenter.post(name: .userLoggedIn, object: nil)
                    }
                } else {
                    print("We DON'T have a match!")
                    self.passwordMatch = false
                }
                
            } catch {
                print("Erorr decoding password object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        } .resume()
    }
    
    func getUserPhoneNumber (with user: UserRepresentation, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL
            .appendingPathComponent(user.username)
            .appendingPathComponent("phoneNumber")
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error { completion(error); return}
            guard let data = data else { completion(NSError()); return}
            
            let decoder = JSONDecoder()
            do {
                let phoneNumber = try decoder.decode(String.self, from: data)
                self.phoneNumber = phoneNumber
            } catch {
                print("Error decoding object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func updateUser (with user: UserRepresentation, completion: @escaping (Error?) -> Void) {
        let registerUserURL = baseURL
                    .appendingPathComponent(user.username)
                    .appendingPathExtension("json")
                var request = URLRequest(url: registerUserURL)
                request.httpMethod = HTTPMethod.put.rawValue
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
                    completion(nil)
                }.resume()
    }
}

