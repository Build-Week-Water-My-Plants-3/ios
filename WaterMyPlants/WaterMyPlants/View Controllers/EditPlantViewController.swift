//
//  EditPlantViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 3/1/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit

class EditPlantViewController: UIViewController {
    
    var plantController: PlantController?
    var plant: Plant? {
        didSet {
            updateValues()
        }
    }
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNickname: UITextField!
    @IBOutlet weak var plantSpecies: UITextField!
    @IBOutlet weak var plantH2OFrequency: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateValues()
    }
    
    // TODO: Need to add delegate so plant detail VC can update itself when edits are made to an existing plant.
    @IBAction func saveChanges(_ sender: UIBarButtonItem) {
        guard let plantController = plantController,
            let nickname = plantNickname.text,
            let species = plantSpecies.text,
            let h2oFrequencyString = plantH2OFrequency.text,
            !h2oFrequencyString.isEmpty,
            let h2oFrequencyInt = Int32(h2oFrequencyString),
            !nickname.isEmpty,
            !species.isEmpty else { return }
        let plantImageData = plantImageView?.image?.pngData()
        
        if let plant = plant {
            plant.nickname = nickname
            plant.species = species
            plant.h2oFrequency = h2oFrequencyInt
            plant.image = plantImageData
            
            plantController.updateExistingPlant(for: plant)
            
            let alertController = UIAlertController(title: "Plant Updated", message: "The plant information was successfully updated.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
            
        } else {
            let newPlant = Plant(nickname: nickname, species: species, h2oFrequency: Int(h2oFrequencyInt), image: plantImageData)
            
            // I think right here is where we assign the plant to the user.
            // something like newPlant.user = userController.user
            
            plantController.put(plant: newPlant)
            let alertController = UIAlertController(title: "New Plant Added", message: "Your plant was successfully added.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
        }
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateValues() {
        guard isViewLoaded else { return }
        
        if let plant = plant {
            title = plant.nickname
            if let plantImage = plant.image {
                plantImageView.image = UIImage(data: plantImage)
            } else {
                plantImageView.image = #imageLiteral(resourceName: "default")
            }
            plantNickname.text = plant.nickname
            plantSpecies.text = plant.species
            plantH2OFrequency.text = "\(plant.h2oFrequency)"
        } else {
            title = "Enter New Plant"
        }
    }
}
