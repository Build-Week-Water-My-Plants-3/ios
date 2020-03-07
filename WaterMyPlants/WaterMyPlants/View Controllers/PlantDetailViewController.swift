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
    var user: User?
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
        plantWateredButton.layer.cornerRadius = 10
        plantWateredButton.layer.cornerRadius = 10
        plantWateredButton.layer.borderWidth = 1
        plantWateredButton.layer.borderColor = CGColor(srgbRed: 0.400, green: 0.659, blue: 0.651, alpha: 1.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .plantSavedToServer, object: nil)
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateLastWateredDate(_ sender: UIButton) {
        guard let plant = plant,
        let plantController = plantController else { return }
        let lastWatered = Date()
        plant.lastWatered = lastWatered
        plantController.updateExistingPlant(for: plant)
        
        let alertController = UIAlertController(title: "Plant Watered!",
                                                message: "You watered your plant today! Next watering date has been updated.",
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) {
            (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
        
    }
    
    // MARK: - Methods
    @objc func updateViews() {

            guard isViewLoaded else { return }
            
            if let plant = plant {
                title = plant.nickname
                if let plantImage = plant.image {
                    plantImageView.image = UIImage(data: plantImage)
                } else {
                    plantImageView.image = #imageLiteral(resourceName: "plantsforuser")
                }
                nicknameLabel.text = plant.nickname
                speciesLabel.text = plant.species
                h2oFreqencyLabel.text = "Water every \(plant.h2oFrequency) day(s)."
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
            return "\(daysRemaining + 1) day(s) until next watering."
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
            editPlantVC.user = user
        }
    }
}

extension UIView {
    func performFlare() {
        func flare() { transform = CGAffineTransform(scaleX: 1.25, y: 1.75) }
        func unflare() { transform = .identity }
        
        UIView.animate(withDuration: 0.15, animations: { flare() }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                unflare()
            }
        })
    }
}
