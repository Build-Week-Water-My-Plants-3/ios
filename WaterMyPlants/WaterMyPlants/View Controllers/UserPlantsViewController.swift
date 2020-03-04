//
//  UserPlantsViewController.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/26/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class UserPlantsViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    var plantController = PlantController()
    var user: User?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
        let searchText = searchBar.text
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "species", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "species",
                                             cacheName: nil)

        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    // MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate: NSPredicate? = nil
        if searchText != "" {
            predicate = NSPredicate(format: "(nickname contains[cd] %@) OR (species contains[cd] %@)", searchText, searchText)
        }
        
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch  {
            print("Fetch Failed!")
        }
    }
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerLocal()
//        user = User(password: "password", phoneNumber: "5558889999", username: "chuck", context: CoreDataStack.shared.mainContext)
//        plantController.fetchPlantsFromServer(user: user!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    func updateViews() {
        guard let user = user else { return }
        plantController.fetchPlantsFromServer(user: user)
    }
}
    // MARK: - Table view data source
extension UserPlantsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        let sectionName = sectionInfo.name
        return sectionName
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlantDetailSegue" {
            guard let plantDetailVC = segue.destination as? PlantDetailViewController else { return }
            plantDetailVC.plantController = plantController
            plantDetailVC.user = user
            
            if let indexPath = tableView.indexPathForSelectedRow {
            plantDetailVC.plant = fetchedResultsController.object(at: indexPath)
            }
        } else if segue.identifier == "NewPlantSegue" {
            guard let newPlantVC = segue.destination as? EditPlantViewController else { return }
            newPlantVC.plantController = plantController
            newPlantVC.user = user
        }
    }
    
    // MARK: - Notification Center
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert]) { grantedBool, _ in
            if grantedBool {
                print("Permission Granted")
            } else {
                print("Permission Denied")
            }
        }
    }
}
