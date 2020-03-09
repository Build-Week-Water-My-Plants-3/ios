//
//  EditPlantViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 3/1/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit
import Photos

class EditPlantViewController: UIViewController {
    
    // MARK: - Properties
    var plantController: PlantController?
    var user: User?
    var plant: Plant? {
        didSet {
            updateValues()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNickname: UITextField!
    @IBOutlet weak var plantSpecies: UITextField!
    @IBOutlet weak var plantH2OFrequency: UITextField!
    @IBOutlet weak var choosePhoto: UIButton!
    @IBOutlet weak var takePhoto: UIButton!
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.plantH2OFrequency.delegate = self
        updateValues()
        let tap = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        choosePhoto.layer.cornerRadius = 10
        choosePhoto.layer.borderWidth = 1
        choosePhoto.layer.borderColor = CGColor(srgbRed: 0.400, green: 0.659, blue: 0.651, alpha: 1.0)
        takePhoto.layer.cornerRadius = 10
        takePhoto.layer.borderWidth = 1
        takePhoto.layer.borderColor = CGColor(srgbRed: 0.400, green: 0.659, blue: 0.651, alpha: 1.0)
    }
    
    // MARK: - Actions
    // Code to request access to the photo library and add a photo to the plant image.
    @IBAction func addNewPhoto(_ sender: UIButton) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
    
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    return
                }
                DispatchQueue.main.async {
                self.presentImagePickerController()
                }
            }
        default:
            break
        }
    }
    
    // MARK: - Take Photo
    @IBAction func takePhoto(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Save Changes
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
        
        // If an existing Plant was passed into the function, get the new values and call updateExistingPlant
        // else, get the values and call the put method.  Also, assign the plant to a user in core data.
        if let plant = plant {
            plant.nickname = nickname
            plant.species = species
            plant.h2oFrequency = h2oFrequencyInt
            plant.image = plantImageData
            
            plantController.updateExistingPlant(for: plant)
            
            let alertController = UIAlertController(title: "Plant Updated",
                                                    message: "The plant information was successfully updated.",
                                                    preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
            
        } else {
            let newPlant = Plant(nickname: nickname, species: species, h2oFrequency: Int(h2oFrequencyInt), image: plantImageData)
            
            // Assign the plant to the user in core data.
             newPlant.user = user
            
            plantController.put(plant: newPlant) { error in
                if error != nil {
                    print("Error occured while PUTing new plant to server: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "New Plant Added",
                                                                message: "Your plant was successfully added.",
                                                                preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
                            self.dismiss(animated: true, completion: nil)
                        }
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // Update views puts the appropriate values in the elements if a plant is passed in, otherwise empty text fields await the user
    private func updateValues() {
        guard isViewLoaded else { return }
        
        if let plant = plant {
            title = plant.nickname
            if let plantImage = plant.image {
                plantImageView.image = UIImage(data: plantImage)
            } else {
                plantImageView.image = #imageLiteral(resourceName: "plantsforuser")
            }
            plantNickname.text = plant.nickname
            plantSpecies.text = plant.species
            plantH2OFrequency.text = "\(plant.h2oFrequency)"
        } else {
            title = "Enter New Plant"
        }
    }
}
