//
//  JournalDetailViewController.swift
//  TripLog
//
//  Created by Tony Jin on 4/25/17.
//  Copyright © 2017 CS466. All rights reserved.
//
// This is the file for the view of a single journal entry.
// It has a segue to the edit journal entry view,
// and has the delete and share entry functionality.
// The single journal entry view can be reached by
// clicking on the journalentry cell from
// either the single trips table or from the journalentries tab

import UIKit
import CoreData
import MessageUI



class JournalDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var journalEntryDetails : JournalEntry? = nil
    var journalEntries : JournalEntryCollection? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fill in the detail information
        
        if let date = journalEntryDetails?.date {
            dateLabel.text = date
        }
        
        if let location = journalEntryDetails?.location {
            locationLabel.text = "Location: " + location
            locationLabel.adjustsFontSizeToFitWidth = true
        }
        
        if let text:NSAttributedString = journalEntryDetails?.text as? NSAttributedString {
            textTextView.attributedText = text
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
    
    
    
    // Handling share function
    @IBAction func shareButtonClicked(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Share", message: "Do you want to share this journal?", preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
            (alert:UIAlertAction!)->Void in
            //Send the journal entry by email
            self.sendEmail()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            // Cancel the share action
        })
        alertController.addAction(shareAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Journal entry shared from TripLog")
            
            var htmlString = ""
            do {
                let data = try textTextView.attributedText.data(from: NSMakeRange(0, textTextView.attributedText.length), documentAttributes: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType])
                htmlString = String(data: data, encoding: String.Encoding.utf8)!
            }catch {
                print("Can't convert attributed string to HTML string")
            }
            mail.setMessageBody(htmlString, isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    
    
    // Handling delete function
    @IBAction func deleteButtonClicked(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert:UIAlertAction!)->Void in
            self.journalEntries?.deleteJournalEntry(self.journalEntryDetails!)
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            // Cancel delete function
        })
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    //MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let destination = segue.destination as? EditJournalViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        destination.journalEntries = journalEntries
        destination.journalEntryDetails = journalEntryDetails
        destination.callback = { (text, date, location, tripName, latitude, longitude) in
            let newEntryID = self.journalEntries?.updateJournalEntry(oldEntry: self.journalEntryDetails!, text:text, date:date, location:location, tripName:tripName, latitude: latitude, longitude: longitude)
            
            // After updating the journal entry in core data, fetch it by ID and display the new information
            do {
                let moc = self.journalEntries?.managedObjectContext
                self.journalEntryDetails = moc?.object(with: newEntryID!) as? JournalEntry
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
        }
        
    }
    
    // Unwind from edit journal entry
    @IBAction func unwindFromEditToDetails(sender: UIStoryboardSegue){

    }


    
  
}
