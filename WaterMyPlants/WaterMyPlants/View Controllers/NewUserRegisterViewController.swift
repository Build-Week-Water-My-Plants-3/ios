//
//  NewUserRegisterViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit

class NewUserRegisterViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    
    var userController = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = CGColor(srgbRed: 0.15, green: 0.30, blue: 0.75, alpha: 1.0)
    }
    
    // MARK: - Action Handlers
    @IBAction func buttonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType
        
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty,
            let phoneNumber = phoneNumberTextField.text,
            !phoneNumber.isEmpty {
            
            let user = UserRepresentation(password: password,
                                          phoneNumber: phoneNumber,
                                          username: username)
            
            userController.signUp(with: user) { error in
                
                if let error = error {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(
                            title: "Sign Up Successfull",
                            message: "Now please log in.",
                            preferredStyle: .alert)
                        let alertAction = UIAlertAction(
                            title: "OK",
                            style: UIAlertAction.Style.default,
                            handler: { action -> Void in
                                self.performSegue(withIdentifier: "SignInSegue", sender: self)
                        })
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true)
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                        self.phoneNumberTextField.text = ""
                    }
                    print("Error occured during sign up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                        self.phoneNumberTextField.text = ""
                        
                        let alertController = UIAlertController(
                            title: "Sign Up not Successfull",
                            message: "Username already exists, please try again.",
                            preferredStyle: .alert)
                        let alertAction = UIAlertAction(
                            title: "OK",
                            style: UIAlertAction.Style.default,
                            handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true)
                        
                    }
                    
                    //                if self.userController.usernameMatch == true {
                    //                    /// perform sign in api call that is on the main thread because its a UI call
                    //                    DispatchQueue.main.async {
                    //                        /// alert window
                    //                        let alertController = UIAlertController(
                    //                            title: "Sign Up Successfull",
                    //                            message: "Now please log in.",
                    //                            preferredStyle: .alert)
                    //                        /// alert button
                    //                        let alertAction = UIAlertAction(
                    //                            title: "OK",
                    //                            style: UIAlertAction.Style.default,
                    //                            handler: { action -> Void in
                    //                                self.performSegue(withIdentifier: "SignInSegue", sender: self)
                    //                        })
                    //                        /// adding action to alert controller
                    //                        alertController.addAction(alertAction)
                    //                        self.present(alertController, animated: true)
                    //
                    //                    }
                    //                } else {
                    //                    DispatchQueue.main.async {
                    //                        /// alert window
                    //                        let alertController = UIAlertController(
                    //                            title: "Sign Up Not Successfull",
                    //                            message: "Username already exists.",
                    //                            preferredStyle: .alert)
                    //                        /// alert button
                    //                        let alertAction = UIAlertAction(
                    //                            title: "OK",
                    //                            style: UIAlertAction.Style.default,
                    //                            handler: nil)
                    //                        /// adding action to alert controller
                    //                        alertController.addAction(alertAction)
                    //                        self.present(alertController, animated: true)
                    //
                }
            }
            
        }
    }
}

