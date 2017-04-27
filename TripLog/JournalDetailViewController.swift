//
//  JournalDetailViewController.swift
//  TripLog
//
//  Created by Lyra Ding on 4/25/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit
import CoreData

class JournalDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    

    
    var newDate = ""
    var newLocation = ""
    var newText = ""
    var newTripName = ""
    
    var journalEntryDetails : JournalEntry? = nil
    var journalEntries : JournalEntryCollection? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let date = journalEntryDetails?.date {
            dateLabel.text = date
        }
        
        if let location = journalEntryDetails?.location {
            locationLabel.text = location
        }
        
        if let text = journalEntryDetails?.text {
            textTextView.text = text
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
//        case "AddBook":
//            guard let navController = segue.destination as? UINavigationController else{
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//            guard let destination = navController.topViewController as? BookDetailViewController else{
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//            destination.type = .new
//            destination.callback = { (title, authorName, year) in
//                self.books.add(title:title, authorName: authorName, year: year)
//            }
        case "EditJournal":
            
            guard let navController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let destination = navController.topViewController as? EditJournalViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
//            guard let cell = sender as? BookListingCell else{
//                fatalError("Unexpected sender: \(sender)")
//            }
//            
//            guard let indexPath = tableView.indexPath(for: cell) else{
//                fatalError("The selected cell can't be found")
//            }
            
        
            destination.journalEntryDetails = journalEntryDetails
            destination.callback = { (text, date, location, tripName) in
                self.journalEntries?.update(oldEntry: self.journalEntryDetails!, text:text, date:date, location:location, tripName:tripName)
                self.newDate = date
                self.newLocation = location
                self.newText = text
                self.newTripName = tripName
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName:"JournalEntry")
//                request.fetchLimit = 1
                
                let datePredicate = NSPredicate(format: "date == %@", self.newDate)
                let locationPredicate = NSPredicate(format: "location == %@", self.newLocation)
                let textPredicate = NSPredicate(format: "text == %@", self.newText)
                let tripNamePredicate = NSPredicate(format: "trip.tripName == %@", self.newTripName)
                let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate,locationPredicate,textPredicate,tripNamePredicate])
                
                request.predicate = andPredicate
                
                do {
                    let moc = self.journalEntries?.managedObjectContext
                    let matches = try moc?.fetch(request)
                    if matches?.count == 0 {
                        fatalError("0 matches for the required journal entry!!!!")
                    } else {
                        self.journalEntryDetails = matches?[0] as? JournalEntry
                        if let date = self.journalEntryDetails?.date {
                            self.dateLabel.text = date
                        }
                        
                        if let location = self.journalEntryDetails?.location {
                            self.locationLabel.text = location
                        }
                        
                        if let text = self.journalEntryDetails?.text {
                            self.textTextView.text = text
                        }
                    }
                } catch {
                    fatalError("Cannot find journal entry")
                }

                
                
                
            }
        
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
        
    }
    
    @IBAction func unwindFromEdit(sender: UIStoryboardSegue){
        
    }


    
    
  
}
