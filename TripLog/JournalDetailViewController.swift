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
    var newText:NSAttributedString? = nil
    var newTripName = ""
    
    var journalEntryDetails : JournalEntry? = nil
    var journalEntries : JournalEntryCollection? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let date = journalEntryDetails?.date {
            dateLabel.text = date
        }
        
        if let location = journalEntryDetails?.location {
            locationLabel.text = "Location: " + location
        }
        
        if let text:NSAttributedString = journalEntryDetails?.text as! NSAttributedString {
            
            
            
//            let newAttributedString = NSMutableAttributedString(attributedString: text)
//            
//            // Enumerate through all the font ranges
//            newAttributedString.enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, newAttributedString.length), options: []) { value, range, stop in
//                guard let currentFont = value as? UIFont else {
//                    return
//                }
//                
//                // An NSFontDescriptor describes the attributes of a font: family name, face name, point size, etc.
//                // Here we describe the replacement font as coming from the "Hoefler Text" family
//                
//                let fontDescriptor = currentFont.fontDescriptor.addingAttributes([UIFontDescriptorFamilyAttribute: "Avenir"])
//                
//                // Ask the OS for an actual font that most closely matches the description above
//                if let newFontDescriptor = fontDescriptor.matchingFontDescriptors(withMandatoryKeys: [UIFontDescriptorFamilyAttribute]).first {
//                    let newFont = UIFont(descriptor: newFontDescriptor, size: 20.0)
//                    newAttributedString.addAttributes([NSFontAttributeName: newFont], range: range)
//                }
//            }
            
            textTextView.attributedText = text
            
            
            
            
//            text.attribute(NSFontAttributeName,
//                                         value: UIFont(
//                                            name: "Avenir",
//                                            size: 20.0)!,
//                                         range: NSRange(
//                                            location: 0,
//                                            length: text.length))
//            textTextView.attributedText = text
//            
//            let font = UIFont(name: "Avenir", size: 20.0)
            

        }
        
        if let title = journalEntryDetails?.trip?.tripName {
            self.title = title
        }
        
        textTextView.font?.withSize(20.0)
        
    }
    
    override func viewDidLayoutSubviews() {
        self.textTextView.setContentOffset(.zero, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func shareButtonClicked(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Share", message: "Do you want to share this journal?", preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
            (alert:UIAlertAction!)->Void in
            print("Share")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        alertController.addAction(shareAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert:UIAlertAction!)->Void in
            self.journalEntries?.delete(self.journalEntryDetails!)
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let destination = segue.destination as? EditJournalViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        destination.journalEntries = journalEntries
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
            let textPredicate = NSPredicate(format: "text == %@", self.newText!)
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
                        self.locationLabel.text = "Location: "+location
                    }
                    
                    if let text = self.journalEntryDetails?.text {
                        self.textTextView.attributedText = text as! NSAttributedString
                    }
                }
            } catch {
                fatalError("Cannot find journal entry")
            }
            
        }
        
    }
    
    @IBAction func unwindFromEdit(sender: UIStoryboardSegue){
        
    }


    
    
  
}
