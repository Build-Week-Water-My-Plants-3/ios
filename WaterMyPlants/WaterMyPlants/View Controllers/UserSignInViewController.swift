//
//  UserSignInViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/25/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class UserSignInViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    var userController: UserController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action Handlers
    @IBAction func buttonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType
        guard let userController = userController else { return }
        
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty,
            let phoneNumber = phoneNumberTextField.text,
            !phoneNumber.isEmpty {
            
            let user = UserRepresentation(identifier: UUID().uuidString,
                                          password: password,
                                          phoneNumber: phoneNumber,
                                          username: username)
            
            if loginType == .signUp {
                userController.signUp(with: user) { error in
                    if let error = error {
                        print("Error occured during sign up: \(error)")
                    } else {
                        /// perform sign in api call that is on the main thread because its a UI call
                        DispatchQueue.main.async {
                            /// alert window
                            let alertController = UIAlertController(
                                title: "Sign Up Successfull",
                                message: "Now please log in.",
                                preferredStyle: .alert)
                            /// alert button
                            let alertAction = UIAlertAction(
                                title: "OK",
                                style: .default,
                                handler: nil)
                            /// adding action to alert controller
                            alertController.addAction(alertAction)
                            /// view alert controller
                            self.present(alertController, animated: true) {
                                self.loginType = .signIn
                                self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                self.signInButton.setTitle("Sign In", for: .normal)
                            }
                        }
                    }
                }
            } else {
                //run sign in API call
                userController.signIn(with: user) { error in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        // switch UI between login types
        if sender.selectedSegmentIndex == 0 {
            /// sign up mode
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            /// sign in mode
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
}

