//
//  UserPlantsViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit
import CoreData

class UserPlantsViewController: UIViewController {
    
    var plantController = PlantController()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "species", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "species",
                                             cacheName: nil)

        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
    /*  for use with possible implementation of a search bar
    var currentSearchText = ""
    */
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fake data for testing
//        let newPlant = Plant(nickname: "Francis", species: "Aloe", h2oFrequency: 14, image: nil)
//        plantController.put(plant: newPlant)
    }
}
    // MARK: - Table view data source
extension UserPlantsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        let sectionName = sectionInfo.name
        return sectionName
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ssZ"
//        let sectionDate: Date = dateFormatter.date(from: sectionName)!
//        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
//        return Date.stringFormattedDate(from: sectionDate)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath)
            as? PlantTableViewCell else { return UITableViewCell() }
        
        let plant = fetchedResultsController.object(at: indexPath)
        cell.plant = plant
        
        return cell
    }

    // Swip to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let plant = fetchedResultsController.object(at: indexPath)
            plantController.deletePlant(for: plant)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
