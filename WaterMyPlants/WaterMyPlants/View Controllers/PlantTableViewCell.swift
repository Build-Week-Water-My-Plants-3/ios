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
    }

}
