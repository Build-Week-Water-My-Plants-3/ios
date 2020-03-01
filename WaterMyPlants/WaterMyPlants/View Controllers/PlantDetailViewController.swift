//
//  PlantDetailViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController {
    
    // MARK: - Properties
    var plantController: PlantController?
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNicknameTextField: UITextField!
    @IBOutlet weak var plantSpeciesTextField: UITextField!
    @IBOutlet weak var plantH2oFrequency: UITextField!
    @IBOutlet weak var nextWateringDateLabel: UILabel!
    @IBOutlet weak var plantWateredButton: UIButton!
    
    // MARK: - View Control Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func addPhotoFromLibrary(_ sender: UIButton) {
        
    }
    
    // MARK: - Methods
    func updateViews() {
        guard isViewLoaded else { return }
        
        plantWateredButton.layer.cornerRadius = 15
        if let plant = plant {
            title = plant.nickname
            if let plantImage = plant.image {
                
            } else {
                plantImageView.image = #imageLiteral(resourceName: "default")
            }
//            plantImageView.image = plant.image  TODO: all the image stuff
            plantNicknameTextField.text = plant.nickname
            plantSpeciesTextField.text = plant.species
            plantH2oFrequency.text = "\(plant.h2oFrequency)"
            let daysRemaining = daysToWateringCalc()
            nextWateringDateLabel.text = daysRemaining
        }
    }
    
    // TODO: write this function once only
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
}
