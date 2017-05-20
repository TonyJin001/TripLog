//
//  TheFixedTripsViewController.swift
//  TripLog
//
//  Created by Vaasu on 4/26/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit
import CoreData

//This is the file for the Table View for the Trips. 
// It has segues to the table view of a specific trip, and to the file to create a new trips.

class TripsTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var tripsTableView: UITableView!
    
    private var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    private let tripEntries = TripCollection() {
        print("Core Data Connected for trips")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tripsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeFetchResultsController()
        
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        
        tripsTableView.rowHeight = 106.5

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initializeFetchResultsController() {
        
        // get all books
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Trip")
        
        // sort by trip name
        let tripSort = NSSortDescriptor(key: "tripName", ascending: true)
        request.sortDescriptors = [tripSort]
        
        // Create the controller using our moc
        let moc = tripEntries.managedObjectContext
        fetchedResultsController  = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        }catch{
            print("Failed to fetch data")
        }
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController!.sections else {
            fatalError("No Sections found")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripsTableViewCell", for: indexPath) as? TripsTableViewCell else {
            fatalError("Can't get cell of the right kind")
        }
        
        guard let trip = self.fetchedResultsController.object(at: indexPath) as? Trip else {
            fatalError("Cannot find entry")
        }

        cell.configureCell(trip: trip)
        
        return cell
    }
    
    
    // MARK: Connect tableview to fetched results controller
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tripsTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tripsTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tripsTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tripsTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tripsTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tripsTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tripsTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tripsTableView.endUpdates()
    }
    
    /* Provides the edit functionality (deleteing rows) */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let trip = self.fetchedResultsController?.object(at: indexPath) as? Trip else{
                fatalError("Cannot find journal entry")
            }
            
            tripEntries.delete(trip)
        }
    }

    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch(segue.identifier ?? ""){
        case "NewTrip":
            guard let destination = segue.destination as? NewTripViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            destination.type = .new
            destination.callback = { (tripName, startDate, endDate) in
                self.tripEntries.add(tripName: tripName, startDate: startDate, endDate: endDate)
            }
            
            
        case "ViewTrip":
            guard let destination = segue.destination as? JournalEntriesViewController else{
            fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? TripsTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tripsTableView.indexPath(for:cell) else {
                fatalError("The Selected cell can't be found")
            }
            
            guard let currentTrip = fetchedResultsController?.object(at:indexPath) as? Trip else {
                fatalError("fetched object was not a JournalEntry")
            }

            destination.type = .oneTrip
            destination.trip = currentTrip
            destination.title = currentTrip.tripName
            destination.hidesBottomBarWhenPushed = true
            
        default:
            fatalError("Unexpected segue identifier")
        }
    }
    @IBAction func unwindFromEdit(sender: UIStoryboardSegue){
        tripsTableView.reloadData()
    }
}
            






