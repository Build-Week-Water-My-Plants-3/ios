//
//  UserSignInViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/25/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit

class UserSignInViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    var userController =  UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.layer.cornerRadius = 10
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = CGColor(srgbRed: 0.15, green: 0.30, blue: 0.75, alpha: 1.0)
    }
    
    // MARK: - Action Handlers
    @IBAction func buttonTapped(_ sender: UIButton) {
        
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
                }
                
                if self.userController.passwordMatch == true {
                    print("true")
                    DispatchQueue.main.async {
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                        self.performSegue(withIdentifier: "PlantSegue", sender: self)
                    }
                } else {
                    print("false")
                    DispatchQueue.main.async {
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                    
                        let alertController = UIAlertController(
                            title: "Sign In UnSuccessfull",
                            message: "Incorrect Password.",
                            preferredStyle: .alert)
                        
                        let alertAction = UIAlertAction(
                            title: "OK",
                            style: UIAlertAction.Style.default,
                            handler: nil)
                        
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            }
            
        }
    }



//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "PlantSegue" {
//            // inject dependencies. injecting this api controller to login view controller so it is shared from this class.
//            if let plantUserVC = segue.destination as? UserPlantsViewController {
//                plantUserVC.userController = userController
//          
//            }
//        }
//    }


}
