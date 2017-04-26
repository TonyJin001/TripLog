//
//  JournalDetailViewController.swift
//  TripLog
//
//  Created by Lyra Ding on 4/25/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

class JournalDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var journalEntryDetails : JournalEntry? = nil
    
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
            
            guard let destination = segue.destination as? EditJournalViewController else{
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
        
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
        
    }

    
    
  
}
