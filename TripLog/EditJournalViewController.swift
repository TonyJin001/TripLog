//
//  EditJournalViewController.swift
//  TripLog
//
//  Created by Lyra Ding on 4/26/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit
import CoreData

class EditJournalViewController: UIViewController {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var journalTextView: UITextView!
    
    var journalEntryDetails:JournalEntry? = nil
    var callback : ((String,String,String,String)->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let date = journalEntryDetails?.date {
            dateTextField.text = date
        }
        
        if let location = journalEntryDetails?.location {
            locationTextField.text = location
        }
        
        if let tripName = journalEntryDetails?.trip?.tripName {
            tripNameTextField.text = tripName
        }
        
        if let text = journalEntryDetails?.text {
            journalTextView.text = text
        }
    }
    
    @IBAction func cancelEditing(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }





    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("The save button was not pressed")
            return
        }
        
        let text = journalTextView.text ?? ""
        let date = dateTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let tripName = tripNameTextField.text ?? ""
        
        if callback != nil{
            callback!(text, date, location,tripName)
        }
    }

}
