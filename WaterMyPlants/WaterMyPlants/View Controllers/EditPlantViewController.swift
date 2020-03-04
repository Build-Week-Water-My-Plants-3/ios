//
//  EditPlantViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 3/1/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit
import Photos

class EditPlantViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateValues()
        let tap = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
    
    //MARK: - Take Photo
    @IBAction func takePhoto(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
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
            
            // I think right here is where we assign the plant to the user.
             newPlant.user = user
            
            plantController.put(plant: newPlant) { error in
                if error != nil {
                    print("Error occured while PUTing new plant to server: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "New Plant Added", message: "Your plant was successfully added.", preferredStyle: .alert)
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
    
    // MARK: - Methods
    // Image picker controller
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Update views puts the appropriate values in the elements if a plant is passed in, otherwise empty text fields await the user
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
    
    // MARK: Image Picker Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        plantImageView.image = resizeImage(image: image, targetSize: CGSize(width: 500.0, height: 500.0))
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Image Resize
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
