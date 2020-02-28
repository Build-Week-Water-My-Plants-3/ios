//
//  PlantTableViewCell.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/27/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var plantNicknameLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var daysToNextWatering: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let plant = plant else { return }
        plantNicknameLabel.text = plant.nickname
        if let plantImageData = plant.image {
            plantImage.image = UIImage(data: plantImageData)
        }
        let daysRemaining = daysToWateringCalc()
        daysToNextWatering.text = daysRemaining
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
        let daysRemaining = Calendar.current.dateComponents([.day], from: today, to: newWaterDate!)
        return "\(daysRemaining)"
    }

}
