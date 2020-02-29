//
//  PlantDetailViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController {
    
    var plantController: PlantController?
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNicknameTextField: UITextField!
    @IBOutlet weak var plantSpeciesTextField: UITextField!
    @IBOutlet weak var plantH2oFrequency: UITextField!
    @IBOutlet weak var nextWateringDateLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        if let plant = plant {
            title = plant.nickname
//            plantImageView.image = plant.image  TODO: all the image stuff
            plantNicknameTextField.text = plant.nickname
            plantSpeciesTextField.text = plant.species
            plantH2oFrequency.text = "\(plant.h2oFrequency)"
            let daysRemaining = daysToWateringCalc()
            nextWateringDateLabel.text = daysRemaining
        }
    }
    
    // This function calculates the next watering date and then subtracts the current date from the next watering date (giving us the time remaining until we need to water the plant again).
    // It takes out the value for the number of days from the result and returns that value in type String.
    func daysToWateringCalc() -> String {
        guard let plant = plant else { return "" }
        guard let lastWatered = plant.lastWatered else { return "" }
        let today = Date()
        var dateComponent = DateComponents()
        dateComponent.day = Int(plant.h2oFrequency)
        let newWaterDate = Calendar.current.date(byAdding: dateComponent, to: lastWatered)
        guard let daysRemaining = Calendar.current.dateComponents([.day], from: today, to: newWaterDate!).day else { return ""}
        if daysRemaining >= 1 {
            return "\(daysRemaining + 1) Days"
        } else {
            return "\(daysRemaining + 1) Day"
        }
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
