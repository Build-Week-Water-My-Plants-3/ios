//
//  UserSignInViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/25/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit

//enum LoginType {
//    case signUp
//    case signIn
//}

class UserSignInViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
//    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    var userController: UserController?
//    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action Handlers
    @IBAction func buttonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType
        guard let userController = userController else { return }
        let phoneNumber = ""
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = UserRepresentation(password: password,
                                          phoneNumber: phoneNumber,
                                          username: username)
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
