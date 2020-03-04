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
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
