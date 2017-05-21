//
//  FirstViewController.swift
//  TripLog
//
//  Created by Lyra Ding on 4/23/17.
//  Copyright © 2017 CS466. All rights reserved.
//
//  This is the file for looking at all the journals in the journals tab, or looking at the journals for just one specific trip.
//  It has segues to view each individual journal entry page, or to create a new journal

import UIKit
import CoreData



class JournalEntriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    
    // Showing all entries/entries from a trip
    var type:JournalEntriesViewType = .all
    
    var trip:Trip?
    
    private var journalEntries = JournalEntryCollection() {
        print("Core Data Connected")
    }
    
    @IBOutlet weak var journalEntriesTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        if type == .oneTrip {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
        
        
        var navController = self.tabBarController?.viewControllers?[1] as! UINavigationController
        var tripTab = navController.viewControllers.first as! TripsTableViewController
        if tripTab.tripEntries == nil {
            tripTab.tripEntries = journalEntries
        }
        
//        if journalEntries.managedObjectContext.hasChanges || (tripTab.tripEntries?.managedObjectContext.hasChanges)!{
//            print ("Has Changed!!!!!!")
//            initializeFetchResultsController()
//        } else {
//            print("no changes!!!!!!")
//        }
        
        if type != .oneTrip {
            initializeFetchResultsController()
        }
        
        journalEntriesTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If launched for the first time, show tutorial
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            performSegue(withIdentifier: "modal", sender: nil)
        }

        journalEntriesTableView.delegate = self
        journalEntriesTableView.dataSource = self
        initializeFetchResultsController()
        journalEntriesTableView.reloadData()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initializeFetchResultsController() {
        // get all journal entries
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"JournalEntry")
        // Filter for trips if necessary
        
        if self.type == .oneTrip && self.trip != nil {
            request.predicate = NSPredicate(format: "trip.tripName == %@", self.trip!.tripName!)
        } else if self.type == .oneTrip && self.trip == nil {
            fatalError("Tripname shouldn't be nill when self.type is oneTrip")
        }

        // sort by author anme and then by title
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        let tripSort = NSSortDescriptor(key: "trip.tripName", ascending: true)
        request.sortDescriptors = [dateSort, tripSort]

        // Create the controller using our moc
        let moc = journalEntries.managedObjectContext
        fetchedResultsController  = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Failed to fetch data")
        }

    }
    
    
    // Functions for Table View
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalEntriesTableViewCell", for: indexPath) as? JournalEntriesTableViewCell else {
            fatalError("Can't get cell of the right kind")
        }
        
        guard let journalEntry = self.fetchedResultsController.object(at: indexPath) as? JournalEntry else {
            fatalError("Cannot find entry")
        }
        
        cell.configureCell(entry: journalEntry)
        
        return cell
    }
    
    // MARK: Connect tableview to fetched results controller
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        journalEntriesTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            journalEntriesTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            journalEntriesTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            journalEntriesTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            journalEntriesTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            journalEntriesTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            journalEntriesTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        journalEntriesTableView.endUpdates()
    }
    
    /* Provides the edit functionality (deleteing rows) */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let journalEntry = self.fetchedResultsController?.object(at: indexPath) as? JournalEntry else{
                fatalError("Cannot find journal entry")
            }
            
            journalEntries.deleteJournalEntry(journalEntry)
        }
    }
    
    // MARK: - Navigation
    
    // prepare to go to the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
        case "AddJournal":

            guard let destination = segue.destination as? EditJournalViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }

            destination.title = "New Journal Entry"
            destination.type = .new
            if self.type == .oneTrip {
                destination.presetTripName = self.trip?.tripName!
            }
            destination.journalEntries = self.journalEntries
            destination.hidesBottomBarWhenPushed = true
            // Called in EditJournalViewController for saving new journal entry
            destination.callback = { (text, date, location, tripName, latitude, longitude) in
                self.journalEntries.addJournalEntry(text:text, date:date, location:location, tripName:tripName, latitude:latitude, longitude: longitude)
            }
            
        case "ViewJournal":
            
            guard let destination = segue.destination as? JournalDetailViewController else {
                fatalError("Unexpected destination")
            }
            
            // Get the journal entry selected and pass to the next view controller
            guard let cell = sender as? JournalEntriesTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = journalEntriesTableView.indexPath(for:cell) else {
                fatalError("The Selected cell can't be found")
            }
            
            guard let journalEntry = fetchedResultsController?.object(at:indexPath) as? JournalEntry else {
                fatalError("fetched object was not a JournalEntry")
            }
            
            destination.journalEntryDetails = journalEntry
            destination.journalEntries = journalEntries
            destination.hidesBottomBarWhenPushed = true
            
        case "EditTrip":
            guard let destination = segue.destination as? NewTripViewController else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            if (self.trip != nil){
                if (self.trip?.startDate == nil || self.trip?.endDate == nil){
                    
                    destination.type = .update((self.trip?.tripName)!, "", "")
                }
                else{
                destination.type = .update((self.trip?.tripName)!, (self.trip?.startDate)!, (self.trip?.endDate)!)
                
                }
                destination.callback = { (tripName, startDate, endDate) in
                    self.journalEntries.updateTrip(oldTrip: self.trip!,tripName: tripName,startDate: startDate,endDate: endDate)
                }
            }
            

        
        case "ViewMap":
            guard let destination = segue.destination as? GoogleMapViewController else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            destination.fetchedResultsController = self.fetchedResultsController
            destination.journalEntries = self.journalEntries
        
        case "modal":
            
            guard let destination = segue.destination as? ModalViewController  else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
        default:
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
        }
        
    }
    
    @IBAction func unwindFromEdit(sender: UIStoryboardSegue){
        journalEntriesTableView.reloadData()
    }


}

enum JournalEntriesViewType {
    case all
    case oneTrip
}
