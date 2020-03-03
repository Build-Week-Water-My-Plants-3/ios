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
    @IBOutlet private weak var signInButton: UIButton!
    
    var userController =  UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                
                if self.userController.match == true {
                    print("true")
                    DispatchQueue.main.async {
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
//        if segue.identifier == "plantSegue" {
//            // inject dependencies. injecting this api controller to login view controller so it is shared from this class.
//            if let loginVC = segue.destination as? UserPlantsViewController {
//                loginVC.userController = userController
//          
//            }
//        }
//    }


}
