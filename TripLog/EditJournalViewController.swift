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
    
    var camera2:UIBarButtonItem!
    var upload2:UIBarButtonItem!
    var toolbar:UIToolbar!

    
    var type:EditType = .edit
    
    var journalEntryDetails:JournalEntry? = nil
    var callback : ((NSAttributedString,String,String,String)->Void)? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTextField.delegate = self
        locationTextField.delegate = self
        tripNameTextField.delegate = self
        journalTextView.delegate = self
        
        dateTextField.tag = 1
        
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        notificationCenter.addObserver(self,selector: #selector(adjustForKeyboard),name:Notification.Name.UIKeyboardWillShow, object:nil)
        
        
        
        // Create a button bar for the number pad
        toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 35)
        
        // Setup the buttons to be put in the system.
        
        camera2 = UIBarButtonItem (title: "Camera", style: .plain, target: self, action: #selector(self.importImage))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        upload2 = UIBarButtonItem (title: "Upload a photo/video", style: .plain, target: self, action: #selector(self.importImage))
        
        
        //Put the buttons into the ToolBar and display the tool bar
        toolbar.setItems([camera2,flexSpace,upload2], animated: false)
        journalTextView.inputAccessoryView = toolbar
        

        
        if self.type != .new {
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
            
            if let text:NSAttributedString = journalEntryDetails?.text as! NSAttributedString {
                journalTextView.attributedText = text
            }
        }
        
        
        // Automatically set the time if this is a new entry
        if self.type == .new {
            let currentDateTime = Date() //Calendar code from stackoverflow
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            dateTextField.text = formatter.string(from: currentDateTime)
            
            journalTextView.text = "Write something..."
            journalTextView.textColor = UIColor.lightGray
            
        }

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
        switch sender.title!{
        case cameraButton.title!:
            image.sourceType = UIImagePickerControllerSourceType.camera
        case uploadButton.title!:
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
            let scaleFactor = oldWidth/(journalTextView.frame.size.width)
            attachment.image = UIImage(cgImage: attachment.image!.cgImage!, scale: scaleFactor, orientation:.up)
            
            //put your NSTextAttachment into and attributedString
            let attString = NSAttributedString(attachment: attachment)
            //add this attributed string to the current position.
            
            journalTextView.text = journalTextView.text + "\n"
            journalTextView.text = journalTextView.text + "\n"
            
            journalTextView.textStorage.insert(attString, at: journalTextView.selectedRange.location)
            
            journalTextView.font = UIFont(name: "Avenir", size: 20.0)
            
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
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    func adjustForKeyboard(notification: Notification) {
        
        var keyboardHeight:CGFloat = 0
        
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
       
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            journalTextView.contentInset = UIEdgeInsets.zero
            
        } else {
            journalTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
//            journalTextView.inputAccessoryView = toolbar
        }
        
        journalTextView.scrollIndicatorInsets = journalTextView.contentInset
        
        let selectedRange = journalTextView.selectedRange
        journalTextView.scrollRangeToVisible(selectedRange)
        
    
//        journalTextView.inputAccessoryView = toolbar
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            let inputView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:240))
            
            
            let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x:0, y:40, width:0, height:0))
            datePickerView.datePickerMode = UIDatePickerMode.date
            inputView.addSubview(datePickerView) // add date picker to UIView
            
            var center:CGPoint = datePickerView.center
            center.x = inputView.center.x
            datePickerView.center = center
            
            
            let doneButton = UIButton(frame: CGRect(x:(self.view.frame.size.width/2) - (100/2), y:0, width:100, height:50))
            doneButton.setTitle("Done", for: UIControlState.normal)
            doneButton.setTitle("Done", for: UIControlState.highlighted)
            doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
            
            inputView.addSubview(doneButton) // add Button to UIView
            
            doneButton.addTarget(self, action: #selector(doneButton(_:)), for: UIControlEvents.touchUpInside) // set button click event
            
            textField.inputView = inputView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControlEvents.valueChanged)
            
            handleDatePicker(datePickerView) // Set the date on start.
        }
        
        

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write something..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func doneButton(_ sender:UIButton)
    {
        dateTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("The save button was not pressed")
            return
        }
        
        let text = journalTextView.attributedText ?? nil
        let date = dateTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let tripName = tripNameTextField.text ?? ""
        
        if callback != nil{
            callback!(text!, date, location,tripName)
        }
    }

}

enum EditType {
    case new
    case edit
}

