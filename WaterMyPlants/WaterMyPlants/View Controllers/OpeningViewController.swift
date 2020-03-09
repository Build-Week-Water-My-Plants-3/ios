//
//  OpeningViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 3/3/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        if user == nil {
            performSegue(withIdentifier: "LandingPageSegue", sender: self)
        }
    }
}
