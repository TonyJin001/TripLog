//
//  FirstViewController.swift
//  TripLog
//
//  Created by Lyra Ding on 4/23/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit
import CoreData

class JournalEntriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    
    private let journalEntries = JournalEntryCollection() {
        print("Core Data Connected")
    }
    
    @IBOutlet weak var journalEntriesTableView: UITableView!
    
    // Dummy data used for testing the table view
    let dummyDataText = ["Last week I went to NYC", "It's Christmas and...", "Today I went to the Empire State Building"]
    let dummyDataDate = ["01/01/17","12/24/16","10/19/16"]
    let dummyDataTripName = ["New York Trip", "", "Fall Break"]
    let dummyDataTripIndex = ["#1","","#2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeFetchResultsController()
        
        // Do any additional setup after loading the view, typically from a nib.
        journalEntriesTableView.delegate = self
        journalEntriesTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeFetchResultsController() {
        // get all books
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"JournalEntry")
        
        // sort by author anme and then by title
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        let tripSort = NSSortDescriptor(key: "trip.tripName", ascending: true)
        request.sortDescriptors = [dateSort, tripSort]
        
        // Create the controller using our moc
        let moc = journalEntries.managedObjectContext
        fetchedResultsController  = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "trip.tripName", cacheName: nil)
      
        //sectionNameKeyPath????
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Failed to fetch data")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalEntriesTableViewCell", for: indexPath) as? JournalEntriesTableViewCell else {
            fatalError("Can't get cell of the right kind")
        }
        
        guard let journalEntry = self.fetchedResultsController.object(at: indexPath) as? JournalEntry else {
            fatalError("Cannot find entry")
        }
        
        cell.configureCell(entry: journalEntry)
        
//        cell.journalEntryTextLabel.text = dummyDataText[indexPath.row]
//        cell.journalEntryDateLabel.text = dummyDataDate[indexPath.row]
//        cell.journalEntryTripNameLabel.text = dummyDataTripName[indexPath.row]
//        cell.journalEntryTripIndexLabel.text = dummyDataTripIndex[indexPath.row]
        
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


}

