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
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        title = "User Sign-In"
        signInButton.layer.cornerRadius = 10
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = CGColor(srgbRed: 0.400, green: 0.659, blue: 0.651, alpha: 1.0)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
            currentUser = User(password: password, phoneNumber: phoneNumber, username: username)
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
    
    private func updateViews() {
        guard isViewLoaded else { return }
        guard let currentUser = currentUser else { return }

        usernameTextField.text = currentUser.username
        passwordTextField.text = currentUser.password
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlantSegue" {
            // inject dependencies. injecting this api controller to login view controller so it is shared from this class.
            if let plantUserVC = segue.destination as? UserPlantsViewController {
//                let plantUserVC = navController.viewControllers.first as? UserPlantsViewController {
                plantUserVC.user = currentUser
            }
        }
    }
}
