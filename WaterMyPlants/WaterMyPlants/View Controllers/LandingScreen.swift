//
//  LandingScreen.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 3/3/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit

class LandingScreen: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = CGColor(srgbRed: 0.15, green: 0.30, blue: 0.75, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
