//
//  EditJournalViewController.swift
//  TripLog
//
//  Created by Lyra Ding on 4/26/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit
import CoreData

class EditJournalViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    
    var type:EditType = .edit
    
    var journalEntryDetails:JournalEntry? = nil
    var callback : ((String,String,String,String)->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTextField.delegate = self
        locationTextField.delegate = self
        tripNameTextField.delegate = self
        journalTextView.delegate = self
        
        

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
        
        // Automatically set the time if this is a new entry
        if self.type == .new {
            let currentDateTime = Date() //Calendar code from stackoverflow
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .short
            dateTextField.text = formatter.string(from: currentDateTime)
        }
        
        journalTextView.layer.borderColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.0).cgColor
        journalTextView.layer.borderWidth = 1.0
        journalTextView.layer.cornerRadius = 5.0

        
    }
    
//    @IBAction func cancelEditing(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func importImage(_ sender: UIBarButtonItem) {
        let image = UIImagePickerController()
        image.delegate = self
        
        // Decide whether the user wants to take a photo or select it from the photo library
        switch sender {
        case cameraButton:
            image.sourceType = UIImagePickerControllerSourceType.camera
        case uploadButton:
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        default:
            fatalError("Source type for image picker unknown")
        }
        
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            // After it's completed
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as?UIImage {
            
            let attachment = NSTextAttachment()
            attachment.image = image
            
            // Scale the image
            let oldWidth = attachment.image!.size.width
            let scaleFactor = oldWidth/(journalTextView.frame.size.width-10)
            attachment.image = UIImage(cgImage: attachment.image!.cgImage!, scale: scaleFactor, orientation:.up)
            
            //put your NSTextAttachment into and attributedString
            let attString = NSAttributedString(attachment: attachment)
            //add this attributed string to the current position.
            journalTextView.textStorage.insert(attString, at: journalTextView.selectedRange.location)
            
        } else {
            // Error
            journalTextView.text = "Didn't get the image"
        }
        
        
        
        self.dismiss(animated: true, completion: nil)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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

enum EditType {
    case new
    case edit
}
