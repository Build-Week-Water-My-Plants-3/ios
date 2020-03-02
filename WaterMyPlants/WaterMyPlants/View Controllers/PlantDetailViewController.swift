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
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var h2oFreqencyLabel: UILabel!
    @IBOutlet weak var nextWateringDateLabel: UILabel!
    @IBOutlet weak var plantWateredButton: UIButton!
    
    // MARK: - View Control Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        plantWateredButton.layer.cornerRadius = 15
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .plantSavedToServer, object: nil)
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    @objc func updateViews() {
        DispatchQueue.main.async {
            guard self.isViewLoaded else { return }
            
            if let plant = self.plant {
                self.title = plant.nickname
                if let plantImage = plant.image {
                    
                } else {
                    self.plantImageView.image = #imageLiteral(resourceName: "default")
                }
                //            plantImageView.image = plant.image  TODO: all the image stuff
                self.nicknameLabel.text = plant.nickname
                self.speciesLabel.text = plant.species
                self.h2oFreqencyLabel.text = "Water every \(plant.h2oFrequency) days"
                let daysRemaining = self.daysToWateringCalc()
                self.nextWateringDateLabel.text = daysRemaining
            }
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
            return "\(daysRemaining + 1) days until next watering."
        } else if daysRemaining >= 0 {
            return "Watering is due tomorrow."
        } else {
            return "Watering is past due!"
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPlantSegue" {
            guard let editPlantVC = segue.destination as? EditPlantViewController else { return }
            
            editPlantVC.plant = plant
            editPlantVC.plantController = plantController
        }
    }
}
