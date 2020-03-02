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
                            style: UIAlertAction.Style.default,
                            handler: { action -> Void in
                                self.performSegue(withIdentifier: "SignInSegue", sender: self)
                        })
                        /// adding action to alert controller
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true)
                        
                    }
                }
            }
        }
    }
}
